resource "aws_cloudwatch_log_group" "parse_judgment" {
  name = "/aws/vendedlogs/states/${var.env}-${var.prefix}-parse-judgment-logs"
}
