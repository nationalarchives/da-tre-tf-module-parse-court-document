resource "aws_sfn_state_machine" "court_document_parse" {
  name     = local.step_function_name
  role_arn = aws_iam_role.court_document_parse.arn
  definition = templatefile("${path.module}/templates/step-function-definition.json.tftpl", {
    arn_lambda_court_document_parse        = aws_lambda_function.court_document_parse.arn
    arn_sns_topic_tre_slack_alerts   = var.common_tre_slack_alerts_topic_arn
    arn_sns_topic_court_document_parse_out = var.notification_topic_arn
    tre_data_bucket                  = var.tre_data_bucket
  })
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.court_document_parse.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  tracing_configuration {
    enabled = true
  }
}
