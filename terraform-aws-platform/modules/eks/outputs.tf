output "cluster_name" {
  description = "EKS cluster name"
  value = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value = aws_eks_cluster.this.endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = aws_security_group.eks_cluster.id
}

output "node_security_group_id" {
  description = "EKS node security group ID."
  value       = aws_security_group.eks_nodes.id
}

output "node_group_name" {
  description = "EKS managed node group name."
  value       = aws_eks_node_group.managed_nodes.node_group_name
}

output "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN."
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "EKS node IAM role ARN."
  value       = aws_iam_role.eks_node_role.arn
}

output "oidc_provider_arn" {
  description = "EKS OIDC provider ARN."
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "EKS OIDC provider URL."
  value       = aws_iam_openid_connect_provider.eks.url
}