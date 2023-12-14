module "vpc" {
  source = "./module-vpc"
  cidr = var.cidr
  subnets = var.subnets
  env = var.env
  vpc_tags = var.vpc_tags
  azs = var.azs
}