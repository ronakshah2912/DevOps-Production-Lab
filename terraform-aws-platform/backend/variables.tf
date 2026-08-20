variable "aws_region" {
  description = "AWS region for Terraform backend resources."
  type        = string
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "environment" {
  description = "Environment tag for Terraform backend resources."
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all backend resources."
  type        = map(string)
}