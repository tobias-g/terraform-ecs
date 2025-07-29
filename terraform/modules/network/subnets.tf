resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 2, 0)
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Exposure    = "public"
    Name        = "${local.prefix}-${data.aws_region.current.name}a-public"
    Description = "ECS example public subnet"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 2, 1)
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Exposure    = "public"
    Name        = "${local.prefix}-${data.aws_region.current.name}b-public"
    Description = "ECS example public subnet"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 2, 2)
  availability_zone = "${data.aws_region.current.name}a"

  tags = {
    Exposure    = "private"
    Name        = "${local.prefix}-${data.aws_region.current.name}a-private"
    Description = "ECS example private subnet"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr, 2, 3)
  availability_zone = "${data.aws_region.current.name}b"

  tags = {
    Exposure    = "private"
    Name        = "${local.prefix}-${data.aws_region.current.name}b-private"
    Description = "ECS example private subnet"
  }
}
