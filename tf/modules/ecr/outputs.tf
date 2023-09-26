output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.helloworld_service.repository_url
}

output "repository_name" {
  description = "The name of the ECR reposiroty"
  value       = aws_ecr_repository.helloworld_service.name
}
