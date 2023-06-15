
A test msg is sent to trigger the module. The message `sns-msg.json` has a source bucket + source key and a uuid substituted before being
put on the "sns_arn" topic in the "aws_profile_target".

`./module_sns_msg.sh tre-in-arn tre-non-prod-user s3_source_bucket s3_source_key`
