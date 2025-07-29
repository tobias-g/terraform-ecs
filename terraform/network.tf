module "network" {
  source      = "./modules/network"
  environment = var.environment
  cidr        = var.cidr
}
