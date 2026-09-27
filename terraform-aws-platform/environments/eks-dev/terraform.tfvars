aws_region   = "ca-central-1"
project_name = "devops-production-lab"
environment  = "eks-dev"

vpc_cidr = "10.40.0.0/20"

availability_zones = [
  "ca-central-1a",
  "ca-central-1b"
]

public_subnet_cidrs = [
  "10.40.1.0/24",
  "10.40.2.0/24"
]

private_subnet_cidrs = [
  "10.40.3.0/24",
  "10.40.4.0/24"
]

enable_nat_gateway = true

eks_cluster_version = "1.34"

eks_node_instance_types = [
  "t3.medium"
]

eks_node_desired_size = 2
eks_node_min_size     = 1
eks_node_max_size     = 3
eks_node_disk_size    = 20

common_tags = {
  Owner       = "Ronak"
  Project     = "devops-production-lab"
  Environment = "eks-dev"
  ManagedBy   = "Terraform"
  CostCenter  = "DevOpsLab"
}