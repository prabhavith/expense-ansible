module "vpc" {
  source = "./module-vpc"
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