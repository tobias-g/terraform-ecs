resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = local.prefix
    Description = "ECS example internet gateway for public subnets"
  }
}
