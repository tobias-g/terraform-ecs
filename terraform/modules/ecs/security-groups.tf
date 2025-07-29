resource "aws_security_group" "ecs" {
  name        = "${local.prefix}-nodejs"
  description = "Allow access from load balancer to ECS for ${local.prefix}-nodejs"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${local.prefix}-nodejs"
    Description = "Allow access from load balancer to ECS for ${local.prefix}-nodejs"
  }
}

resource "aws_security_group_rule" "ecs_egress" {
  description       = "Allow egress anywhere for ${local.prefix}-nodejs"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = -1
  security_group_id = aws_security_group.ecs.id
  type              = "egress"
}

resource "aws_security_group_rule" "ecs_ingress" {
  description              = "Allow loadbalancer ingress to ECS ${local.prefix}-nodejs"
  source_security_group_id = aws_security_group.load_balancer.id
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "TCP"
  security_group_id        = aws_security_group.ecs.id
  type                     = "ingress"
}

resource "aws_security_group" "load_balancer" {
  name        = "${local.prefix}-nodejs-lb"
  description = "Allow access to load balancer for ${local.prefix}-nodejs"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${local.prefix}-nodejs-lb"
    Description = "Allow access to load balancer for ${local.prefix}-nodejs"
  }
}

resource "aws_security_group_rule" "load_balancer_egress" {
  description              = "Allow egress for ${local.prefix}-nodejs"
  source_security_group_id = aws_security_group.ecs.id
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "TCP"
  security_group_id        = aws_security_group.load_balancer.id
  type                     = "egress"
}

resource "aws_security_group_rule" "load_balancer_https_ingress" {
  description       = "Allow loadbalancer HTTPS ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  security_group_id = aws_security_group.load_balancer.id
  type              = "ingress"
}

resource "aws_security_group_rule" "load_balancer_http_ingress" {
  description       = "Allow loadbalancer HTTPS ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  security_group_id = aws_security_group.load_balancer.id
  type              = "ingress"
}
