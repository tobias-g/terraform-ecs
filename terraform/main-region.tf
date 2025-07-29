module "main_region" {
  source = "./modules/main-region"
  environment = var.environment
  cidr = var.cidr
}
