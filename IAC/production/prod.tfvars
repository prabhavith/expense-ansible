cidr = "10.20.0.0/16"
env = "prod"
subnets = {
  public = ["10.20.1.0/24" , "10.20.2.0/24" ]
  web = ["10.20.3.0/24" , "10.20.4.0/24" ]
  backend = ["10.20.5.0/24" , "10.20.6.0/24" ]
  db = ["10.20.7.0/24" , "10.20.8.0/24" ]
}

vpc_tags = {
  org = "test.com"
  location = "mars"
  mail = "test@gmail.com"
  Environment = "prod"
}

azs = ["us-east-1a" , "us-east-1b"]

account_id = "180933357369"
default_vpc_id = "vpc-09d00167426afa5db"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rt = "rtb-0b0ede23ba4b2dd65"

bastion_cidr = ["172.31.40.242/32"]

backend = {
  component     = "backend"
  min_count     = 1
  max_count     = 2
  app_port      = 8080
  instance_type = "t2.small"
}

frontend = {
  component     = "frontend"
  min_count     = 1
  max_count     = 2
  app_port      = 80
  instance_type = "t2.small"
}


kms_arn = "5a38f8ed-e4fe-4315-bad0-359f4487e811"