output "court_document_parse_in_queue_arn" {
  value       = aws_sqs_queue.tre_court_document_parse_in.arn
  description = "ARN of the TRE-parse-judgment SQS Queue"
}

output "court_document_parse_lambda_role" {
  value       = aws_iam_role.court_document_parse_lambda_role.arn
  description = "ARN of the parse judgment Lamda Role"
}

output "court_document_parse_role_arn" {
  value       = aws_sfn_state_machine.court_document_parse.role_arn
  description = "ARN of the Parse Judgment Step Function Role"

}
