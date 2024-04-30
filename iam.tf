resource "aws_iam_role" "court_document_parse" {
  name                 = "${var.env}-${var.prefix}-parse-judgment-role"
  assume_role_policy   = data.aws_iam_policy_document.court_document_parse_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
  inline_policy {
    name   = "parse-judgment-policies"
    policy = data.aws_iam_policy_document.court_document_parse_machine_policy.json
  }
}

data "aws_iam_policy_document" "court_document_parse_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "court_document_parse_machine_policy" {
  statement {
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:PutObject",
      "s3:PutObjectTagging"
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets"
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid     = "InvokeLambdaPolicy"
    effect  = "Allow"
    actions = ["lambda:InvokeFunction"]
    resources = [
      aws_lambda_function.court_document_parse.arn
    ]
  }
}

# Lambda Roles

# Role for the lambda functions in court_document_parse step-function
resource "aws_iam_role" "court_document_parse_lambda_role" {
  name                 = "${var.env}-${var.prefix}-parse-judgment-lambda-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
}

resource "aws_iam_role_policy_attachment" "court_document_parse_lambda_logs" {
  role       = aws_iam_role.court_document_parse_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
}

data "aws_iam_policy_document" "court_document_parse_lambda_kms_policy_data" {
  statement {
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = var.s3_bucket_kms_arns
  }
}

resource "aws_iam_policy" "court_document_parse_lambda_kms_policy" {
  name        = "${var.env}-${var.prefix}-court-document-parse-s3-key"
  description = "The KMS key policy for court document parse lambda"
  policy      = data.aws_iam_policy_document.court_document_parse_lambda_kms_policy_data.json
}

resource "aws_iam_role_policy_attachment" "court_document_parse_lambda_key" {
  role       = aws_iam_role.court_document_parse_lambda_role.name
  policy_arn = aws_iam_policy.court_document_parse_lambda_kms_policy.arn
}

resource "aws_iam_role_policy_attachment" "court_document_parse_step_function_key" {
  role       = aws_iam_role.court_document_parse.name
  policy_arn = aws_iam_policy.court_document_parse_lambda_kms_policy.arn
}

# Role for the parse-judgment step-function trigger
resource "aws_iam_role" "court_document_parse_trigger" {
  name                 = "${var.env}-${var.prefix}-court-document-parse-trigger-lambda-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  permissions_boundary = var.tre_permission_boundary_arn
  inline_policy {
    name   = "${var.env}-${var.prefix}-court-document-parse-trigger"
    policy = data.aws_iam_policy_document.court_document_parse_trigger.json
  }
}

resource "aws_iam_role_policy_attachment" "court_document_parse_sqs_lambda_trigger" {
  role       = aws_iam_role.court_document_parse_trigger.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

# Lambda policy documents

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "court_document_parse_trigger" {
  statement {
    actions   = ["states:StartExecution"]
    effect    = "Allow"
    resources = [aws_sfn_state_machine.court_document_parse.arn]
  }
}

# SQS Polciy

data "aws_iam_policy_document" "tre_court_document_parse_in_queue" {
  statement {
    actions = ["sqs:SendMessage"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "sns.amazonaws.com"
      ]
    }
    resources = [
      aws_sqs_queue.tre_court_document_parse_in.arn
    ]
  }
}


resource  "aws_iam_policy" "parser_lambda_s3_policy" {
  name        = "${var.env}-${var.prefix}-parser-lambda-s3-bucket-input-read"
  description = "Policy allowing parser lambda s3-bucket-input read"
  policy      =  data.aws_iam_policy_document.read_s3-bucket-input.json
}

data "aws_iam_policy_document" "read_s3-bucket-input" {
  dynamic "statement" {
    for_each = var.parse_s3_bucket_input
    content {
      effect    = "Allow"
      actions   = ["s3:GetObject"]
      resources = [
        "arn:aws:s3:::${statement.value}",
        "arn:aws:s3:::${statement.value}/*"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "court_document_lambda_s3_input" {
  role      = aws_iam_role.court_document_parse_lambda_role.name
  policy_arn = aws_iam_policy.parser_lambda_s3_policy.arn
}
