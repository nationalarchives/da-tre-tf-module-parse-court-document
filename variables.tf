variable "env" {
  description = "Name of the environment to deploy"
  type        = string
}

variable "prefix" {
  description = "Transformation Engine prefix"
  type        = string
}


variable "account_id" {
  description = "Account ID where Image for the Lambda function will be"
  type        = string
}

variable "common_tre_slack_alerts_topic_arn" {
  description = "ARN of the Common TRE Slack Alerts SNS Topic"
  type        = string
}

variable "parse_judgment_version" {
  description = "Parse Judgment Step Function version (update if Step Function flow or called Lambda function versions change)"
  type        = string

}

variable "parse_judgment_image_versions" {
  description = "Latest version of Images for Lambda Functions"
  type = object({
    tre_parse_judgment = string
    tre_sqs_sf_trigger = string
  })
}

variable "common_tre_internal_topic_arn" {
  description = "The TRE out SNS topic ARN"
  type        = string
}

variable "tre_dlq_alerts_lambda_function_name" {
  description = "TRE DLQ Alerts Lambda Function Name"
  type        = string
}

variable "tre_permission_boundary_arn" {
  description = "ARN of the TRE permission boundary policy"
  type        = string
}

variable "ecr_uri_host" {
  description = "The hostname part of the management account ECR repository; e.g. ACCOUNT.dkr.ecr.REGION.amazonaws.com"
  type        = string
}

variable "ecr_uri_repo_prefix" {
  description = "The prefix for Docker image repository names to use; e.g. foo/ in ACCOUNT.dkr.ecr.REGION.amazonaws.com/foo/tre-bar"
  type        = string
}

variable "tre_data_bucket" {
  description = "TRE Data Bucket Name"
  type        = string
}

variable "parser_s3_bucket_input" {
  description = "The s3 input bucket "
  type        = list(string)
}
