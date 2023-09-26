output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public.*.id
}

output "default_security_group_id" {
  description = "The ID of the default security group in the VPC"
  value       = aws_security_group.default.id
}
