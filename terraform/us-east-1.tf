module "us_east_1" {
  source           = "./modules/replica-region"
  environment      = var.environment
  cidr             = "10.0.8.0/21"
  code_deploy_role = module.main_region.code_deploy_role

  providers = {
    aws = aws.us-east-1
  }
}