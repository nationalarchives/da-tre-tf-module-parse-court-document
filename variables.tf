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

variable "court_document_parse_version" {
  description = "Parse Judgment Step Function version (update if Step Function flow or called Lambda function versions change)"
  type        = string

}

variable "court_document_parse_image_versions" {
  description = "Latest version of Images for Lambda Functions"
  type = object({
    tre_court_document_parse = string
    tre_sqs_sf_trigger = string
  })
}

variable "notification_topic_arn" {
  description = "The ARN of the SNS topic to notify"
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

variable "parse_s3_bucket_input" {
  description = "Allowable s3 input buckets for parser"
  type        = list(string)
}

variable "s3_bucket_kms_arns" {
  description = "arns of kms for buckets parser lambda will read from (sample data bucket used in tests, and in future fcl input bucket) "
  type        = list(string)
}
