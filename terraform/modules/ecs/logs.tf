resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/ecs-nodejs"
  retention_in_days = 7

  tags = {
    Name        = "/ecs/ecs-nodejs"
    Description = "ECS example NodeJS application logs"
  }
}