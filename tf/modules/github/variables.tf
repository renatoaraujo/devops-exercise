variable "helloworld_user_access_key" {
  type        = string
  description = "AWS helloworld user access key"
  sensitive   = true
}

variable "helloworld_user_secret_key" {
  type        = string
  description = "AWS helloworld user secret key"
  sensitive   = true
}

variable "github_repository" {
  type        = string
  description = "GitHub repository"
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "ecr_repository_name" {
  description = "The ECR repository name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "The ECS service name"
  type        = string
}