terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-ecs-sandbox-state"
    key    = "state.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      App         = "terraform-ecs"
      Repo        = "https://github.com/tobias-g/terraform-ecs"
      Environment = var.environment
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"

  default_tags {
    tags = {
      App         = "terraform-ecs"
      Repo        = "https://github.com/tobias-g/terraform-ecs"
      Environment = var.environment
    }
  }
}