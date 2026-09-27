variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT gateway."
  type        = bool
}

# variable "allowed_ssh_cidr" {
#   description = "CIDR block allowed for SSH access."
#   type        = string
# }

variable "common_tags" {
  description = "Common resources tags."
  type        = map(string)
}

variable "s3_readonly_bucket_arns" {
  description = "List of S3 bucket ARNs for read-only access."
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the ASG."
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the ASG."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the ASG."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the ASG."
  type        = number
  default     = 4
}

variable "cluster_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.34"
}

variable "node_instance_types" {
  description = "List of EC2 instance types for the EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes in the EKS managed node group."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes in the EKS managed node group."
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum number of worker nodes in the EKS managed node group."
  type        = number
  default     = 1
}

variable "node_disk_size" {
  description = "Disk size for each worker node in the EKS managed node group."
  type        = number
  default     = 20
}