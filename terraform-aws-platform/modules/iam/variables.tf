variable "project_name" {
  description = "Project name used for naming IAM resources."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, stage, or prod"
  type        = string
}

variable "s3_readonly_bucket_arns" {
  description = "List of S3 bucket ARNs for read-only access."
  type        = list(string)
  default     = []
}

variable "cloudwatch_log_group_arns" {
  description = "List of CloudWatch log group ARNs allowed for logging"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common resource tags for all IAM resources."
  type        = map(string)
  default     = {}
}