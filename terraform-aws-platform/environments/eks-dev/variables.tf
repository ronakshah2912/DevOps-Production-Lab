variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway."
  type        = bool
  default     = true
}

variable "eks_cluster_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.30"
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS managed node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_desired_size" {
  description = "Desired EKS node count."
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum EKS node count."
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum EKS node count."
  type        = number
  default     = 3
}

variable "eks_node_disk_size" {
  description = "EKS managed node disk size in GiB."
  type        = number
  default     = 20
}

variable "common_tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}