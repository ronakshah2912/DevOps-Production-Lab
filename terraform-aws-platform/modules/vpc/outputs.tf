output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.My-VPC.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.My-VPC.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.My-Public-Subnet[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.My-Private-Subnet[*].id
}
output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.My-NAT-Gateway[0].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.My-IGW.id
}

output "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "Security Group ID for the application"
  value       = aws_security_group.app.id
}

output "s3_vpc_endpoint_id" {
  description = "S3 Gateway VPC Endpoint ID."
  value       = aws_vpc_endpoint.s3.id
}

output "cloudwatch_logs_vpc_endpoint_id" {
  description = "CloudWatch Logs Interface VPC Endpoint ID."
  value       = aws_vpc_endpoint.cloudwatch_logs.id
}