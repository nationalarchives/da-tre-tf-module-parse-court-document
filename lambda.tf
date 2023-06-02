resource "aws_lambda_function" "court_document_parse" {
  image_uri     = "${var.ecr_uri_host}/lambda_functions/${var.prefix}-run-judgment-parser:${var.court_document_parse_image_versions.tre_court_document_parse}"
  package_type  = "Image"
  function_name = local.lambda_name_court_document_parse
  role          = aws_iam_role.court_document_parse_lambda_role.arn
  memory_size   = 1536
  timeout       = 900

  tags = {
    ApplicationType = ".NET"
  }
}

# court_document_parse_step_function_trigger
resource "aws_lambda_function" "court_document_parse_trigger" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}${var.prefix}-sqs-sf-trigger:${var.court_document_parse_image_versions.tre_sqs_sf_trigger}"
  package_type  = "Image"
  function_name = local.lambda_name_trigger
  role          = aws_iam_role.court_document_parse_trigger.arn
  timeout       = 30

  environment {
    variables = {
      "TRE_STATE_MACHINE_ARN"    = aws_sfn_state_machine.court_document_parse.arn
      "TRE_CONSIGNMENT_KEY_PATH" = "parameters.reference"
    }
  }
}

resource "aws_lambda_event_source_mapping" "court_document_parse_in_sqs" {
  batch_size                         = 1
  function_name                      = aws_lambda_function.court_document_parse_trigger.function_name
  event_source_arn                   = aws_sqs_queue.tre_court_document_parse_in.arn
  maximum_batching_window_in_seconds = 0
}
