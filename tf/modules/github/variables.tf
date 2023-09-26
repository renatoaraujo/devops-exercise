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
