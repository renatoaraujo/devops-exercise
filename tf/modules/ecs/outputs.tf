output "service_name" {
  description = "The name of the ECS service."
  value       = aws_ecs_service.app.name
}

output "security_group" {
  description = "The security group of the ECS service."
  value       = var.ecs_security_group
}
