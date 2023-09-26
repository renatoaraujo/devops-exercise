# AWS Region
variable "region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
  default     = "eu-west-2"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "helloworld"
}

variable "container_image" {
  description = "The Docker image for the application"
  type        = string
  default     = "helloworld-service"
}

variable "container_port" {
  description = "The port the application listens on"
  type        = number
  default     = 80
}

variable "github_repository" {
  description = "The github repository name"
  type        = string
  default     = "devops-exercise"
}