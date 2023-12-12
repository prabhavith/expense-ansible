module "vpc" {
  source = "./module-vpc"
  cidr = var.cidr
  subnets = var.subnets
  env = var.env
}