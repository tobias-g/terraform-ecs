resource "aws_lb_target_group" "blue" {
  name                 = "${local.prefix}-nodejs-blue"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 0

  health_check {
    healthy_threshold   = 5
    path                = "/"
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${local.prefix}-nodejs-blue"
    Description = "ECS example NodeJS app blue target group"
  }
}

resource "aws_lb_target_group" "green" {
  name                 = "${local.prefix}-nodejs-green"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = 0

  health_check {
    healthy_threshold   = 5
    path                = "/"
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${local.prefix}-nodejs-green"
    Description = "ECS example NodeJS app green target group"
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  lifecycle {
    # will be managed by CodeDeploy
    ignore_changes = [
      action,
    ]
  }

  tags = {
    Name        = "${local.prefix}-nodejs main"
    Description = "ECS example NodeJS loadbalancer/target group HTTPS listener"
  }
}

