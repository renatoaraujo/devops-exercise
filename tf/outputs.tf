output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnets_ids
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.service_name
}

output "ecs_security_group" {
  description = "The security group of the ECS service"
  value       = module.ecs.security_group
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = module.dynamodb.table_name
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}
