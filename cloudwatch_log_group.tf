resource "aws_cloudwatch_log_group" "parse_judgment" {
  name = "${var.env}-${var.prefix}-parse-judgment-logs"
}
