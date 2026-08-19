locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

resource "aws_vpc" "My-VPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "My-IGW" {
  vpc_id = aws_vpc.My-VPC.id

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )
}

resource "aws_subnet" "My-Public-Subnet" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.My-VPC.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.avability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
      Tier = "Public"
    }
  )
}

resource "aws_subnet" "My-Private-Subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.My-VPC.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.avability_zones[count.index]

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-private-subnet-${count.index + 1}"
      Tier = "Private"
    }
  )
}

resource "aws_eip" "My-NAT-EIP" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-nat-eip"
    }
  )

}

resource "aws_nat_gateway" "My-NAT-Gateway" {
  count = var.enable_nat_gateway ? 1 : 0

  subnet_id     = aws_subnet.My-Public-Subnet[0].id
  allocation_id = aws_eip.My-NAT-EIP[0].id

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-nat-gateway"
    }
  )

  depends_on = [aws_internet_gateway.My-IGW]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.My-VPC.id

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-public-rt"
    }
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.My-IGW.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.My-Public-Subnet)
  subnet_id      = aws_subnet.My-Public-Subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.My-VPC.id
  count  = length(aws_subnet.My-Private-Subnet)

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-private-rt"
    }
  )
}

resource "aws_route" "private_nat_access" {
  count = var.enable_nat_gateway ? length(aws_subnet.My-Private-Subnet) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.My-NAT-Gateway[0].id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.My-Private-Subnet)
  subnet_id      = aws_subnet.My-Private-Subnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Allow HTTP and HTTPS traffic to public load balancers"
  vpc_id      = aws_vpc.My-VPC.id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow outbound to application tier"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Allow application traffic only from ALB security group."
  vpc_id      = aws_vpc.My-VPC.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  ingress {
    description = "Allow SSH only from allowed internal CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }
  egress {
    description = "Allow outbound HTTPS for updates and AWS API access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-app-sg"
    }
  )
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "${local.name_prefix}-vpce-sg"
  description = "Allow HTTPS access to interface VPC endpoints from inside VPC."
  vpc_id      = aws_vpc.My-VPC.id

  ingress {
    description = "Allow HTTPS from VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    description = "Allow outbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-vpce-sg"
    }
  )
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.My-VPC.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-s3-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = aws_vpc.My-VPC.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.My-Private-Subnet[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(
    local.tags,
    {
      Name = "${local.name_prefix}-cloudwatch-logs-endpoint"
    }
  )
}

data "aws_region" "current" {}