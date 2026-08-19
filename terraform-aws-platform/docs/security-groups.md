# Security Group Rules

## ALB Security Group

Inbound:

| Protocol | Port | Source | Purpose |

| TCP | 80 | 0.0.0.0/0 | Public HTTP access |
| TCP | 443 | 0.0.0.0/0 | Public HTTPS access |

Outbound:

| Protocol | Port | Destination | Purpose |

| All | All | VPC CIDR | Forward traffic to application tier |

## Application Security Group

Inbound:

| Protocol | Port | Source | Purpose |

| TCP | 8080 | ALB Security Group | Application traffic from ALB only |
| TCP | 22 | Internal VPC CIDR | Restricted SSH access for lab validation only |

Outbound:

| Protocol | Port | Destination | Purpose |

| TCP | 443 | 0.0.0.0/0 | HTTPS outbound for updates and AWS APIs |

## VPC Endpoint Security Group

Inbound:

| Protocol | Port | Source | Purpose |

| TCP | 443 | VPC CIDR | Private HTTPS access to AWS services |

## Least-Privilege Approach

- Application tier does not allow public inbound traffic.
- Public access is limited to ALB ports 80 and 443.
- Private workloads use NAT Gateway for outbound internet access.
- AWS service access is supported using VPC endpoints where possible.
- SSH is restricted and should be replaced with Session Manager in production.