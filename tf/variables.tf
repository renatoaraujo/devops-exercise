variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
  default     = "eu-west-2"
}

variable "container_port" {
  description = "The port the application listens on"
  type        = number
  default     = 8080
}

variable "github_repository" {
  description = "The github repository name"
  type        = string
  default     = "devops-exercise"
}