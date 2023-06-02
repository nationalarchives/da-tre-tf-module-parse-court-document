locals {
  resource_prefix            = "${var.env}-${var.prefix}"
  step_function_name         = "${local.resource_prefix}-parse-judgment"
  lambda_name_court_document_parse = "${local.resource_prefix}-parse-judgment-lambda"
  lambda_name_trigger        = "${local.resource_prefix}-court-document-parse-trigger"
  tre_data_bucket            = "arn:aws:s3:::${var.tre_data_bucket}"
}
