# AWS Region
variable "region" {
  description = "The AWS region to deploy the infrastructure in."
  type        = string
  default     = "eu-west-2"
}

# Application name (used for naming resources)
variable "app_name" {
  description = "The name of the application."
  type        = string
  default     = "helloworld"
}

# DynamoDB table name
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "BirthdayTable"
}

variable "container_image" {
  description = "The Docker image for the application."
  type        = string
  # Replace with the path to your Docker image
  default = "your_docker_image_path"
}

variable "container_port" {
  description = "The port the application listens on."
  type        = number
  default     = 80
}