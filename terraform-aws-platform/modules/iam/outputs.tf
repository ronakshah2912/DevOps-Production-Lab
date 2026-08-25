output "ec2_instance_role_name" {
  description = "EC2 instance IAM role name."
  value       = aws_iam_role.ec2_instance_role.name
}

output "ec2_instance_role_arn" {
  description = "EC2 instance IAM role ARN."
  value       = aws_iam_role.ec2_instance_role.arn
}

output "ec2_instance_profile_name" {
  description = "EC2 instance IAM profile name."
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "lambda_execution_role_name" {
  description = "Lambda execution IAM role name."
  value       = aws_iam_role.lambda_execution_role.name
}

output "lambda_execution_role_arn" {
  description = "Lambda execution IAM role ARN."
  value       = aws_iam_role.lambda_execution_role.arn
}

output "cloudwatch_logging_policy_arn" {
  description = "CloudWatch logging IAM policy ARN."
  value       = aws_iam_policy.cloudwatch_logging_policy.arn
}

output "s3_readonly_policy_arn" {
  description = "S3 read-only IAM policy ARN."
  value       = try(aws_iam_policy.s3_readonly_policy[0].arn, null)
}

output "lambda_least_privilege_s3_policy_arn" {
  description = "Lambda least-privilege S3 IAM policy ARN."
  value       = try(aws_iam_policy.lambda_least_privilege_s3_policy[0].arn, null)
}