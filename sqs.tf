resource "aws_sqs_queue" "tre_court_document_parse_in" {
  name = "${var.env}-${var.prefix}-parse-judgment-in"
  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.tre_court_document_parse_in_deadletter.arn}"
    maxReceiveCount     = 5
  })
  sqs_managed_sse_enabled = true
}

resource "aws_sqs_queue_policy" "tre_court_document_parse_in" {
  queue_url = aws_sqs_queue.tre_court_document_parse_in.id
  policy    = data.aws_iam_policy_document.tre_court_document_parse_in_queue.json
}

resource "aws_sqs_queue" "tre_court_document_parse_in_deadletter" {
  name                    = "${var.env}-${var.prefix}-parse-judgment-in-deadletter"
  sqs_managed_sse_enabled = true
}

resource "aws_lambda_event_source_mapping" "tre_court_document_parse_in_dlq" {
  batch_size                         = 1
  function_name                      = var.tre_dlq_alerts_lambda_function_name
  event_source_arn                   = aws_sqs_queue.tre_court_document_parse_in_deadletter.arn
  maximum_batching_window_in_seconds = 0
}
