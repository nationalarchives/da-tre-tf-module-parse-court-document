output "parse_court_document_in_queue_arn" {
  value       = aws_sqs_queue.tre_parse_court_document_in.arn
  description = "ARN of the TRE-parse-judgment SQS Queue"
}

output "parse_court_document_lambda_role" {
  value       = aws_iam_role.parse_court_document_lambda_role.arn
  description = "ARN of the parse judgment Lamda Role"
}

output "parse_court_document_role_arn" {
  value       = aws_sfn_state_machine.parse_court_document.role_arn
  description = "ARN of the Parse Judgment Step Function Role"

}
