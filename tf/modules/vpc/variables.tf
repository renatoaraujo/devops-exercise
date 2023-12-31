variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "aws_region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
}

variable "cloudwatch_log_group_vpc_flow_logs_arn" {
  description = "The CW log group dsn for the vpc flow"
  type        = string
}

variable "log_flow_role_arn" {
  type = string
}