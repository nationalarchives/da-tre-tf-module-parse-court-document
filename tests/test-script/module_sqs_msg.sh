#!/usr/bin/env bash
set -e

main() {
  if [ $# -ne 5 ]; then
    echo "Usage: sqs_url s3_bucket_source s3_object_bagit aws_profile_source aws_profile_target"
    return 1
  fi

  local sqs_url="${1:?}"
  local s3_bucket_source="${2:?}"
  local s3_object_bagit="${3:?}"
  local aws_profile_source="${4:-${AWS_PROFILE:?}}"
  local aws_profile_target="${5:-${AWS_PROFILE:?}}"

  printf 'sns_arn="%s"\n' "${sqs_url}"
  printf 'aws_profile_source="%s"\n' "${aws_profile_source}"
  printf 'aws_profile_target="%s"\n' "${aws_profile_target}"

  printf 'AWS S3 listing for source profile "%s":\n' "${aws_profile_source}"
  aws --profile "${aws_profile_source}" s3 ls

  printf 'AWS S3 listing for target profile "%s":\n' "${aws_profile_target}"
  aws --profile "${aws_profile_target}" s3 ls

  local s3_path_bagit="s3://${s3_bucket_source}/${s3_object_bagit}"
  printf 'AWS S3 listing for target consignment "%s":\n' "${s3_path_bagit:?}"
  aws --profile "${aws_profile_source}" s3 ls "${s3_path_bagit}"

  local pre_signed_url
  pre_signed_url="$(aws --profile "${aws_profile_source}" \
      s3 presign "s3://${s3_bucket_source}/${s3_object_bagit}" \
      --expires-in "${presigned_url_expiry_secs:-60}")"

  local test_uuid
  test_uuid="$(uuidgen | tr '[:upper:]' '[:lower:]')"

  message_string="$(jq -R -s '.' < sqs-msg.json )"
  message_string_with_url="${message_string/XXX_presigned_url_XXX/$pre_signed_url}"
  message_string_with_url_and_uuid="${message_string_with_url/XXX_uuid_XXX/$test_uuid}"
  msg_to_publish="{\"Message\" : ${message_string_with_url_and_uuid}}"
  printf 'Publishing Message:\n%s\n' "${msg_to_publish:?}"
  aws --profile "${aws_profile_target:?}" sqs send-message \
    --queue-url "${sqs_url:?}" \
    --message-body "${msg_to_publish:?}"
}

main "$@"
