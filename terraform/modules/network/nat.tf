# For better resilience we should have a NAT in each AZ we have private subnets
# in but I'm cheap so just using one on AZ a.
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name        = "${local.prefix}-nat"
    Description = "ECS example NAT gateway"
  }
}

resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "${local.prefix}-nat"
    Description = "ECS example NAT gateway IP"
  }
}
