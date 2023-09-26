variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "container_port" {
  description = "The port the application listens on"
  type        = number
}

variable "public_subnets_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "alb_security_group" {
  description = "The security group for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
