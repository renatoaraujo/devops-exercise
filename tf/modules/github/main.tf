resource "github_actions_secret" "aws_account_id" {
  repository      = var.github_repository
  secret_name     = "AWS_ACCOUNT_ID"
  plaintext_value = var.aws_account_id
}

resource "github_actions_secret" "helloworld_user_access_key" {
  repository      = var.github_repository
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.helloworld_user_access_key
}

resource "github_actions_secret" "helloworld_user_secret_key" {
  repository      = var.github_repository
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.helloworld_user_secret_key
}

resource "github_actions_variable" "ecr_repository_name" {
  repository    = var.github_repository
  variable_name = "ECR_REPOSITORY_NAME"
  value         = var.ecr_repository_name
}

resource "github_actions_variable" "ecs_cluster_name" {
  repository    = var.github_repository
  variable_name = "ECS_CLUSTER_NAME"
  value         = var.ecs_cluster_name
}

resource "github_actions_variable" "ecs_service_name" {
  repository    = var.github_repository
  variable_name = "ECS_SERVICE_NAME"
  value         = var.ecs_service_name
}