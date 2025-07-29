resource "aws_acm_certificate" "main" {
  domain_name       = "ecs-nodejs.${local.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "ecs-nodejs.${local.domain}"
    Description = "ECS example NodeJS application domain"
  }
}