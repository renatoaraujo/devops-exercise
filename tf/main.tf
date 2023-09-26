terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

data "aws_caller_identity" "current" {}

module "vpc" {
  source = "./modules/vpc"

  # If you want to override the default CIDR values, you can do so here:
  # vpc_cidr = "10.1.0.0/16"
  # public_subnets_cidr = ["10.1.1.0/24", "10.1.2.0/24"]
}

module "ecs" {
  source = "./modules/ecs"

  container_image    = var.container_image
  container_port     = var.container_port
  public_subnets_ids = module.vpc.public_subnets_ids
  ecs_security_group = module.vpc.default_security_group_id
}

module "alb" {
  source = "./modules/alb"

  container_port     = var.container_port
  public_subnets_ids = module.vpc.public_subnets_ids
  alb_security_group = module.vpc.default_security_group_id
  vpc_id             = module.vpc.vpc_id
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "ecr" {
  source = "./modules/ecr"
}

module "iam" {
  source = "./modules/iam"

  aws_account_id = data.aws_caller_identity.current.account_id
}

module "github_secrets" {
  source = "./modules/github"

  github_repository          = "devops-exercise"
  aws_account_id             = data.aws_caller_identity.current.account_id
  helloworld_user_access_key = module.iam.helloworld_user_access_key
  helloworld_user_secret_key = module.iam.helloworld_user_secret_key
}
