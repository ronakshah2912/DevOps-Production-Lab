variable "project_name" {
  description = "project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "environment name such as dev, staging, prod"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB and ASG will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  type        = string
}

variable "app_security_group_id" {
  description = "Security group ID for private EC2 application instances."
  type        = string
}

variable "ec2_instance_profile_name" {
  description = "IAM instance profile name for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum ASG size."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum ASG size."
  type        = number
  default     = 4
}

variable "common_tags" {
  description = "Common tags for all resources."
  type        = map(string)
  default     = {}
}