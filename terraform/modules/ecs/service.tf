resource "aws_ecs_service" "nodejs" {
  name                              = "ecs-nodejs"
  cluster                           = aws_ecs_cluster.main.arn
  task_definition                   = "ecs-nodejs:${data.aws_ecs_task_definition.nodejs.revision}"
  desired_count                     = 1
  health_check_grace_period_seconds = 300
  propagate_tags                    = "TASK_DEFINITION"
  launch_type                       = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    container_name   = "ecs-nodejs"
    target_group_arn = aws_lb_target_group.green.arn
    container_port   = 3000
  }

  lifecycle {
    # will be managed by CodeDeploy
    ignore_changes = [
      load_balancer,
      task_definition,
    ]
  }

  tags = {
    Name        = "ecs-nodejs"
    Description = "ECS service for our NodeJS app"
  }
}
