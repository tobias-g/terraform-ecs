# Most of the ECS stuff we'll setup in the ecs module to encapsulate it but
# since we will want to deploy to multiple regions some resources that are
# global are defined outside the module. An example being the IAM roles (we
# don't/can't deploy a copy of these per region as we would get name clashes).

data "aws_iam_policy_document" "execution" {
  statement {
    sid = "ECRAndLogs"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailibility",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"] # todo we can tighten this to certain log groups and ecrs
  }
}

resource "aws_iam_policy" "execution" {
  name        = "${local.prefix}-execution"
  description = "ECS execution role for ${var.environment}"
  policy      = data.aws_iam_policy_document.execution.json

  tags = {
    Name        = "${local.prefix}-execution"
    Description = "ECS execution policy for ${var.environment}"
  }
}

data "aws_iam_policy_document" "execution_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name               = "${local.prefix}-execution"
  assume_role_policy = data.aws_iam_policy_document.execution_assume.json

  tags = {
    Name        = "${local.prefix}-execution"
    Description = "ECS execution role for ${var.environment}"
  }
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.execution.arn
}

data "aws_iam_policy_document" "task" {
  statement {
    sid = "LogAccess"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]
    resources = ["*"] # todo we can tighten this to certain log groups
  }
}

resource "aws_iam_policy" "task" {
  name        = "${local.prefix}-task"
  description = "ECS task policy for ${var.environment}"
  policy      = data.aws_iam_policy_document.task.json

  tags = {
    Name        = "${local.prefix}-task"
    Description = "ECS task policy for ${var.environment}"
  }
}

data "aws_iam_policy_document" "task_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task" {
  name               = "${local.prefix}-task"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json

  tags = {
    Name        = "${local.prefix}-task"
    Description = "ECS task role for ${var.environment}"
  }
}

data "aws_iam_policy_document" "code_deploy_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "code_deploy" {
  name               = "${local.prefix}-code-deploy"
  assume_role_policy = data.aws_iam_policy_document.code_deploy_assume_role.json

  tags = {
    Name        = "${local.prefix}-code-deploy"
    Description = "IAM role for ECS code deploy jobs"
  }
}

resource "aws_iam_role_policy_attachment" "code_deploy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.code_deploy.name
}

module "ecs_nodejs" {
  source           = "./modules/ecs"
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  private_subnets  = module.network.private_subnets
  public_subnets   = module.network.public_subnets
  code_deploy_role = aws_iam_role.code_deploy.arn
}
