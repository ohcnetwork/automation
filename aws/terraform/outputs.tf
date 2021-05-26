output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "region" {
  description = "AWS region"
  value       = var.region
}

# AZs
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc.azs
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.eks_cluster_name
}