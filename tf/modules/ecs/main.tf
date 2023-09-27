resource "aws_ecs_cluster" "main" {
  name = "helloworld-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "helloworld-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "helloworld-service"
      image = format("%s:latest", var.ecr_repository_url)

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
      environment = [
        {
          name  = "DATABASE_DSN",
          value = "https://dynamodb.${var.aws_region}.amazonaws.com"
        },
        {
          name  = "SERVICE_PORT",
          value = "8080"
        },
        {
          name  = "AWS_REGION",
          value = var.aws_region
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = var.cloudwatch_log_group_name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "helloworld-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets_ids
    security_groups = [var.ecs_security_group]
  }

  desired_count = var.desired_task_count
}
