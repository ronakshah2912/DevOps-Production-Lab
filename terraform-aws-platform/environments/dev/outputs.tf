output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "alb_security_group_id" {
  value = module.vpc.alb_security_group_id
}

output "app_security_group_id" {
  value = module.vpc.app_security_group_id
}

output "ec2_instance_role_name" {
  value = module.iam.ec2_instance_role_name
}

output "ec2_instance_profile_name" {
  value = module.iam.ec2_instance_profile_name
}

output "lambda_execution_role_name" {
  value = module.iam.lambda_execution_role_name
}

output "cloudwatch_logging_policy_arn" {
  value = module.iam.cloudwatch_logging_policy_arn
}

output "s3_readonly_policy_arn" {
  value = module.iam.s3_readonly_policy_arn
} 