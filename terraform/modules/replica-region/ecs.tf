module "ecs_nodejs" {
  source           = "../ecs"
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  private_subnets  = module.network.private_subnets
  public_subnets   = module.network.public_subnets
  code_deploy_role = var.code_deploy_role
}
