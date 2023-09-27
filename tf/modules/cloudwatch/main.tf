resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "helloworld-service-logs"
  retention_in_days = 3
}