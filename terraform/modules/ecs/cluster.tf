resource "aws_ecs_cluster" "main" {
  name = local.prefix

  # Disable these as I don't want to pay for extra custom metrics but in a real
  # production environment this would likely be enabled.
  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name        = local.prefix
    Description = "ECS example cluster"
  }
}
