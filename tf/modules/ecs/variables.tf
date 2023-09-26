variable "app_name" {
  description = "The name of the application."
  type        = string
}

variable "container_image" {
  description = "The Docker image for the application."
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
  default     = "256"
}

variable "task_memory" {
  description = "The amount of memory to allocate for the task."
  type        = string
  default     = "512"
}

variable "desired_task_count" {
  description = "The number of tasks to run."
  type        = number
  default     = 1
}

variable "public_subnets_ids" {
  description = "The IDs of the public subnets."
  type        = list(string)
}

variable "ecs_security_group" {
  description = "The security group for the ECS service."
  type        = string
}
