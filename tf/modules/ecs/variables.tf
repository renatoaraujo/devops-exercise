variable "ecr_repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

variable "container_port" {
  description = "The port the application listens on."
  type        = number
  default     = 80
}

variable "task_cpu" {
  description = "The amount of CPU to allocate for the task."
  type        = string
  default     = "2048"
}

variable "task_memory" {
  description = "The amount of memory to allocate for the task."
  type        = string
  default     = "4096"
}

variable "desired_task_count" {
  description = "The number of tasks to run."
  type        = number
  default     = 2
}

variable "public_subnets_ids" {
  description = "The IDs of the public subnets."
  type        = list(string)
}

variable "ecs_security_group" {
  description = "The security group for the ECS service."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "The role arn for ECS execution"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "The CW log group name"
  type        = string
}