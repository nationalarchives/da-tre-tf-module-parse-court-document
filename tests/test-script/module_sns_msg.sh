#!/usr/bin/env bash
set -e

main() {
  if [ $# -lt 4 ] || [ $# -gt 4 ]; then
    echo "Usage: sns_arn aws_profile_target s3_bucket_source s3_key_source"
    return 1
  fi

  local sns_arn="${1:?}"
  local aws_profile_target="${2:?}"
  local s3_bucket_source="${3:?}"
  local s3_key_source="${4:?}"

  printf 'sns_arn="%s"\n' "${sns_arn}"
  printf 'aws_profile_target="%s"\n' "${aws_profile_target}"

  local test_uuid
  test_uuid="$(uuidgen | tr '[:upper:]' '[:lower:]')"

  message_string=$(cat sns-msg.json)
  message_string_with_bucket="${message_string/XXX_bucket_XXX/$s3_bucket_source}"
  message_string_with_bucket_and_key="${message_string_with_bucket/XXX_key_XXX/$s3_key_source}"
  message_string_with_bucket_and_key_and_uuid="${message_string_with_bucket_and_key/XXX_uuid_XXX/$test_uuid}"
  msg_to_publish="${message_string_with_bucket_and_key_and_uuid}"

  printf 'Publishing Message:\n%s\n' "${msg_to_publish:?}"
  aws --profile "${aws_profile_target:?}" sns publish \
    --topic-arn "${sns_arn}" \
    --message "${msg_to_publish:?}"
}

main "$@"
