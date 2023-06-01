resource "aws_cloudwatch_log_group" "parse_court_document" {
  name = "/aws/vendedlogs/states/${var.env}-${var.prefix}-parse-judgment-logs"
}
