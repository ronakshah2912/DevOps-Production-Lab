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

output "alb_dns_name" {
  value = module.ec2_asg_alb.alb_dns_name
}

output "autoscaling_group_name" {
  value = module.ec2_asg_alb.autoscaling_group_name
}

output "target_group_name" {
  value = module.ec2_asg_alb.target_group_name
}

output "high_cpu_alarm_name" {
  value = module.ec2_asg_alb.high_cpu_alarm_name
}

output "unhealthy_hosts_alarm_name" {
  value = module.ec2_asg_alb.unhealthy_hosts_alarm_name
}

output "target_response_time_alarm_name" {
  value = module.ec2_asg_alb.target_response_time_alarm_name
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "node_group_name" {
  value = module.eks.node_group_name
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "eks_node_role_arn" {
  value = module.eks.eks_node_role_arn
}