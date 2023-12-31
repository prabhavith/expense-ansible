cidr = "10.10.0.0/16"
env = "dev"
subnets = {
  public = ["10.10.1.0/24" , "10.10.2.0/24" ]
  web = ["10.10.3.0/24" , "10.10.4.0/24" ]
  backend = ["10.10.5.0/24" , "10.10.6.0/24" ]
  db = ["10.10.7.0/24" , "10.10.8.0/24" ]
}

vpc_tags = {
  org = "test.com"
  location = "mars"
  mail = "test@gmail.com"
  Environment = "dev"
}

azs = ["us-east-1a" , "us-east-1b"]

account_id = "180933357369"
default_vpc_id = "vpc-09d00167426afa5db"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_rt = "rtb-0b0ede23ba4b2dd65"

bastion_cidr = ["172.31.40.242/32"]