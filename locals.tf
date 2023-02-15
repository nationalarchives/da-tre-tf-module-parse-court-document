locals {
  resource_prefix              = "${var.env}-${var.prefix}"
  step_function_name           = "${local.resource_prefix}-parse-judgment"
  lambda_name_parse_judgment   = "${local.resource_prefix}-parse-judgment-lambda"
  lambda_name_trigger          = "${local.resource_prefix}-parse-judgment-trigger"
}
