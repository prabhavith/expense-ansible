module "vpc" {
  source = "./modules/vpc"
  cidr = var.cidr
  subnets = var.subnets
  env = var.env
  vpc_tags = var.vpc_tags
  azs = var.azs
  account_id = var.account_id
  default_vpc_id = var.default_vpc_id
  default_vpc_cidr = var.default_vpc_cidr
  default_vpc_rt = var.default_vpc_rt
}

module "backend" {
  source = "./modules/app"
  backend = var.backend
  env = var.env
  vpc_cidr = module.vpc.vpc_cidr
  vpc_id = module.vpc.vpc_id
  app_tags = var.vpc_tags
  subnets = var.subnets
  bastion_cidr = var.bastion_cidr
}