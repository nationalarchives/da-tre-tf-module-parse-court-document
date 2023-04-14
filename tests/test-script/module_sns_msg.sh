#!/usr/bin/env bash
set -e

main() {
  if [ $# -lt 2 ] || [ $# -gt 5 ]; then
    echo "Usage: sns_arn aws_profile_target [aws_profile_source] [s3_bucket_source] [ps3_object_docx]"
    return 1
  fi

  local sns_arn="${1:?}"
  local aws_profile_target="${2:?}"
  local aws_profile_source="${3:-""}"
  local s3_bucket_source="${4:-""}"
  local s3_object_docx="${5:-""}"

  printf 'sns_arn="%s"\n' "${sns_arn}"
  printf 'aws_profile_target="%s"\n' "${aws_profile_target}"
  printf 'aws_profile_source="%s"\n' "${aws_profile_source}"

  local docx_url
  #if no bucket source (and no s3 object docx) then use default, otherwise make a presigned url for docx
  if [ "$s3_bucket_source" = "" ]
  then
          printf "Using Default docx"
          docx_url="https://tna-caselaw-assets.s3.eu-west-2.amazonaws.com/eat/2022/1/eat_2022_1.docx"
#          docx_url="https://tre-testing"
  else
          local s3_path_docx="s3://${s3_bucket_source}/${s3_object_docx}"
          printf 'AWS S3 listing for source docx "%s":\n' "${s3_path_docx:?}"
          aws --profile "${aws_profile_source}" s3 ls "${s3_path_docx}"
          docx_url="$(aws --profile "${aws_profile_source}" \
              s3 presign "s3://${s3_bucket_source}/${s3_object_docx}" \
              --expires-in "${presigned_url_expiry_secs:-60}")"
  fi
  printf 'docx_url="%s"\n' "${docx_url}"
#  sleep 2m
  local test_uuid
  test_uuid="$(uuidgen | tr '[:upper:]' '[:lower:]')"

  message_string=$(cat sns-msg.json)
  message_string_with_url="${message_string/XXX_docx_url_XXX/$docx_url}"
  message_string_with_url_and_uuid="${message_string_with_url/XXX_uuid_XXX/$test_uuid}"
  msg_to_publish="${message_string_with_url_and_uuid}"

  printf 'Publishing Message:\n%s\n' "${msg_to_publish:?}"
  aws --profile "${aws_profile_target:?}" sns publish \
    --topic-arn "${sns_arn}" \
    --message "${msg_to_publish:?}"
}

main "$@"
