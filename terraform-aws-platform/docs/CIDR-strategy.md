# CIDR Strategy

## VPC CIDR

10.10.0.0/16

## Public Subnets

10.10.1.0/24 - ca-central-1a
10.10.2.0/24 - ca-central-1b

## Private Subnets

10.10.3.0/24 - ca-central-1a
10.10.4.0/24 - ca-central-1b

## Design Rationale

1. /16 VPC CIDR provides enough address space for future expansion.
2. Public subnets are reserved for internet-facing resources such as Application Load Balancers.
3. Private subnets are reserved for application workloads, databases, internal services, and Kubernetes nodes.
4. Separate subnets across two Availability Zones improve high availability.
5. Private workloads use NAT Gateway for outbound internet access without direct inbound exposure.