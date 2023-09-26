resource "aws_ecs_cluster" "main" {
  name = "helloworld-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "helloworld-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "helloworld"
    image = var.container_image
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "helloworld-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Effect = "Allow",
    }]
  })
}

resource "aws_ecs_service" "app" {
  name            = "helloworld-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.public_subnets_ids
    security_groups = [var.ecs_security_group]
  }

  desired_count = var.desired_task_count
}
