provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  avability_zones      = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  allowed_ssh_cidr     = var.allowed_ssh_cidr

  common_tags = var.common_tags
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment

  s3_readonly_bucket_arns   = var.s3_readonly_bucket_arns
  cloudwatch_log_group_arns = ["arn:aws:logs:${var.aws_region}:*:log-group:/aws/${var.project_name}/${var.environment}/*"]
  common_tags               = var.common_tags
}