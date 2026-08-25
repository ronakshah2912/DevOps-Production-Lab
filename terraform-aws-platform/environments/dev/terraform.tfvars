aws_region           = "ca-central-1"
project_name         = "Devops-lab"
environment          = "dev"
vpc_cidr             = "10.10.0.0/20"
availability_zones   = ["ca-central-1a", "ca-central-1b"]
public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_cidrs = ["10.10.3.0/24", "10.10.4.0/24"]
enable_nat_gateway   = true
allowed_ssh_cidr     = "10.10.0.0/20"
s3_readonly_bucket_arns = [
"arn:aws:s3:::ronak-devops-lab-terraform-state-ca-central-1"]
common_tags = {
  owner       = "Ronak"
  Environment = "dev"
  Project     = "Devops-production-lab"
  costCenter  = "DevOps-Lab"
  ManagedBy   = "Terraform"
}