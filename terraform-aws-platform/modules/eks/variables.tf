variable "project_name" {
  description = "Project name used for EKS resource naming"
  type = string
}

variable "environment" {
  description = "Environment name such as dev, stage, or prod."
  type = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type = string
  default = "1.34"
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  type = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker node"
  type = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs useful for load balancers."
  type = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint access."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint access."
  type        = bool
  default     = true
}

variable "node_instance_types" {
  description = "EC2 instance types for managed node group."
  type = list(string)
  default = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes in the managed node group."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes in the managed node group."
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum number of worker nodes in the managed node group."
  type        = number
  default     = 1
}

variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes."
  type        = number
  default     = 20
}
variable "common_tags" {
  description = "Common tags for all EKS resources"
  type = map(string)
  default = {}
}