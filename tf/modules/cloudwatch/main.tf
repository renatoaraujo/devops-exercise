resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "helloworld-service-logs"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "vpc-flow-logs"
  retention_in_days = 7
}
