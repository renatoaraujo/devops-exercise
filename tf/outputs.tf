output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnets_ids
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

output "helloworld_user_access_key" {
  description = "The access key ID for the helloworld-user"
  value       = module.iam.helloworld_user_access_key
  sensitive   = true
}

output "helloworld_user_secret_key" {
  description = "The secret access key for the helloworld-user"
  value       = module.iam.helloworld_user_secret_key
  sensitive   = true
}
