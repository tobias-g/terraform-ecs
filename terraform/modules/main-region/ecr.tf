resource "aws_ecr_repository" "main" {
  name                 = "${local.prefix}-nodejs"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Name        = "${local.prefix}-nodejs"
    Description = "Example ECS elastic container registry for NodeJS Docker image"
  }
}
