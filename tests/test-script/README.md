
A test msg is sent to trigger the module. THe messge `sns-msg.json` has a docx_url and a uuid substituted before being
put on the "sns_arn" topic in the "aws_profile_target".

Use an availaible public docx_url or use optional params "aws_profile_source", "s3_bucket_source" & "s3_object_docx"
to have one made.

with a public docx url use:
`./module_sns_msg.sh tre-in-arn tre-non-prod-user s3_object_docx`

or to make a presigned url for the docx (there is one for example in dev-te-testdata) use:
`./module_sns_msg.sh tre-in-arn tre-non-prod-user da-transform-sample-data/test-judgments/test.docx tre-management-user dev-te-testdata`
