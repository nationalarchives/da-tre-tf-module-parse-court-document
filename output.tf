output "parse_judgment_in_queue_arn" {
  value       = aws_sqs_queue.tre_parse_judgment_in.arn
  description = "ARN of the TRE-parse-judgment SQS Queue"
}

output "parse_judgment_lambda_role" {
  value       = aws_iam_role.parse_judgment_lambda_role.arn
  description = "ARN of the parse judgment Lamda Role"
}

output "parse_judgment_role_arn" {
  value       = aws_sfn_state_machine.parse_judgment.role_arn
  description = "ARN of the Parse Judgment Step Function Role"

}
