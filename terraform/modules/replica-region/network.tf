module "network" {
  source      = "../network"
  environment = var.environment
  cidr        = var.cidr
}
