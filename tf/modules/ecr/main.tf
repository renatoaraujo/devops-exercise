resource "aws_ecr_repository" "helloworld_service" {
  name                 = "helloworld-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "helloworld-ecr-repo"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [image_tag_mutability, image_scanning_configuration]
  }
}


resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.helloworld_service.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection    = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
