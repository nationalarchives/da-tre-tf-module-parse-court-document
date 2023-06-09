resource "aws_cloudwatch_log_group" "court_document_parse" {
  name = "/aws/vendedlogs/states/${var.env}-${var.prefix}-parse-judgment-logs"
}
