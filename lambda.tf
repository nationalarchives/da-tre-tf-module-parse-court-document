resource "aws_lambda_function" "parse_court_document" {
  image_uri     = "${var.ecr_uri_host}/lambda_functions/${var.prefix}-run-judgment-parser:${var.parse_court_document_image_versions.tre_parse_court_document}"
  package_type  = "Image"
  function_name = local.lambda_name_parse_court_document
  role          = aws_iam_role.parse_court_document_lambda_role.arn
  memory_size   = 1536
  timeout       = 900

  tags = {
    ApplicationType = ".NET"
  }
}

# parse_court_document_step_function_trigger
resource "aws_lambda_function" "parse_court_document_trigger" {
  image_uri     = "${var.ecr_uri_host}/${var.ecr_uri_repo_prefix}${var.prefix}-sqs-sf-trigger:${var.parse_court_document_image_versions.tre_sqs_sf_trigger}"
  package_type  = "Image"
  function_name = local.lambda_name_trigger
  role          = aws_iam_role.parse_court_document_trigger.arn
  timeout       = 30

  environment {
    variables = {
      "TRE_STATE_MACHINE_ARN"    = aws_sfn_state_machine.parse_court_document.arn
      "TRE_CONSIGNMENT_KEY_PATH" = "parameters.reference"
    }
  }
}

resource "aws_lambda_event_source_mapping" "parse_court_document_in_sqs" {
  batch_size                         = 1
  function_name                      = aws_lambda_function.parse_court_document_trigger.function_name
  event_source_arn                   = aws_sqs_queue.tre_parse_court_document_in.arn
  maximum_batching_window_in_seconds = 0
}
