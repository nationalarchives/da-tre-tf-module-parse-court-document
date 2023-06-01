resource "aws_sfn_state_machine" "parse_court_document" {
  name     = local.step_function_name
  role_arn = aws_iam_role.parse_court_document.arn
  definition = templatefile("${path.module}/templates/step-function-definition.json.tftpl", {
    arn_lambda_parse_court_document        = aws_lambda_function.parse_court_document.arn
    arn_sns_topic_tre_slack_alerts   = var.common_tre_slack_alerts_topic_arn
    arn_sns_topic_parse_court_document_out = var.common_tre_internal_topic_arn
    tre_data_bucket                  = var.tre_data_bucket
  })
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.parse_court_document.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  tracing_configuration {
    enabled = true
  }
}
