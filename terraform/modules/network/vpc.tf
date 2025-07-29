resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = local.prefix
    Description = "ECS example VPC"
  }
}

# Bring default security group into IaC so we can manage the rules (remove them)
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "default"
    Description = "Default security group (not used)"
  }
}
