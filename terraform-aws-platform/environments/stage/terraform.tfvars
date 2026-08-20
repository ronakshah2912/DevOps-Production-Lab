aws_region           = "ca-central-1"
project_name         = "Devops-lab"
environment          = "stage"
vpc_cidr             = "10.20.0.0/20"
availability_zones   = ["ca-central-1a", "ca-central-1b"]
public_subnet_cidrs  = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnet_cidrs = ["10.20.3.0/24", "10.20.4.0/24"]
enable_nat_gateway   = true
allowed_ssh_cidr     = "10.20.0.0/20"
common_tags = {
  owner       = "Ronak"
  Environment = "stage"
  Project     = "Devops-production-lab"
  costCenter  = "DevOps-Lab"
  ManagedBy   = "Terraform"
}