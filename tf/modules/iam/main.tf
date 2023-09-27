resource "aws_iam_user" "helloworld_user" {
  name = "helloworld-user"
}

resource "aws_iam_role" "github_actions" {
  name = "GitHubActionsDeployRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = ["sts:AssumeRole", "sts:TagSession"],
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.aws_account_id}:user/${aws_iam_user.helloworld_user.name}"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_full_access" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_full_access" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_user_policy" "helloworld_user_policy" {
  name = "helloworldUserAssumeRolePolicy"
  user = aws_iam_user.helloworld_user.name

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = aws_iam_role.github_actions.arn
      },
      {
        Effect   = "Allow",
        Action   = "sts:TagSession",
        Resource = aws_iam_role.github_actions.arn
      }
    ]
  })
}

resource "aws_iam_access_key" "helloworld_user_key" {
  user = aws_iam_user.helloworld_user.name
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "helloworld-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_logging" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "vpc_flow_logs" {
  name        = "VPCFlowLogsToCloudWatch"
  description = "Grants permissions to publish VPC flow logs to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "VPCFlowLogsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs" {
  role       = aws_iam_role.vpc_flow_logs.name
  policy_arn = aws_iam_policy.vpc_flow_logs.arn
}

