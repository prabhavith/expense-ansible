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
  env = var.env
  vpc_cidr = module.vpc.vpc_cidr
  vpc_id = module.vpc.vpc_id
  app_tags = var.vpc_tags
  subnets = var.subnets["web"]
  bastion_cidr = var.bastion_cidr
  sub_ids = module.vpc.app_sub_ids
  app_port = var.backend["app_port"]
  component = var.backend["component"]
  instance_type = var.backend["instance_type"]
  min_count = var.backend["min_count"]
  max_count = var.backend["max_count"]
  kms_arn = var.kms_arn

}

module "frontend" {
  depends_on = [module.backend]
  source = "./modules/app"
  env = var.env
  vpc_cidr = module.vpc.vpc_cidr
  vpc_id = module.vpc.vpc_id
  app_tags = var.vpc_tags
  subnets = var.subnets["public"]
  bastion_cidr = var.bastion_cidr
  sub_ids = module.vpc.web_sub_ids
  app_port = var.frontend["app_port"]
  component = var.frontend["component"]
  instance_type = var.frontend["instance_type"]
  min_count = var.frontend["min_count"]
  max_count = var.frontend["max_count"]
  kms_arn = var.kms_arn
}

module "public-alb" {
  source = "./modules/alb"

  alb_port        = 80
  alb_tags        = var.vpc_tags
  component       = "frontend"
  env             = var.env
  in_cidr         = ["0.0.0.0/0"]
  internal        = "false"
  subnets         = module.vpc.public_sub_ids
  tg_arn          = module.frontend.target_group
  vpc_id          = module.vpc.vpc_id
}

module "backend-alb" {
  source = "./modules/alb"

  alb_port        = 8080
  alb_tags        = var.vpc_tags
  component       = "backend"
  env             = var.env
  in_cidr         = var.subnets["web"]
  internal        = "true"
  subnets         = module.vpc.app_sub_ids
  tg_arn          = module.backend.target_group
  vpc_id          = module.vpc.vpc_id
}

module "parameters" {
  source = "./modules/ssm"
  app_alb = module.backend-alb.app_alb
  db_ip = var.db_ip
}