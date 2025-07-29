resource "aws_lb" "main" {
  name                       = "${local.prefix}-nodejs"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.load_balancer.id]
  subnets                    = var.public_subnets
  drop_invalid_header_fields = true
  enable_deletion_protection = true

  tags = {
    Name        = "${local.prefix}-nodejs"
    Description = "ECS example NodeJS service load balancer"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name        = "${local.prefix}-nodejs"
    Description = "ECS example NodeJS service HTTP listener redirects to HTTPS"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.main.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Teapot"
      status_code  = "417"
    }
  }

  tags = {
    Name        = "${local.prefix}-nodejs"
    Description = "ECS example NodeJS service HTTPS listener forwards to ECS once service is deployed"
  }
}
