module "main_region" {
  source      = "./modules/main-region"
  environment = var.environment
  cidr        = "10.0.0.0/21"
}
