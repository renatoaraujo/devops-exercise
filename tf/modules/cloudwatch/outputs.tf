output "cloudwatch_log_group_ecs_log_name" {
  value =  aws_cloudwatch_log_group.ecs_logs.name
}

output "cloudwatch_log_group_vpc_flow_logs_arn" {
  value =  aws_cloudwatch_log_group.vpc_flow_logs.arn
}