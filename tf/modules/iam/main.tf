resource "aws_iam_user" "helloworld_user" {
  name = "helloworld-user"
}

resource "aws_iam_role" "github_actions" {
  name = "GitHubActionsDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession"],
        Effect = "Allow",
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
    Version = "2012-10-17",
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
