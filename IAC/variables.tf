variable "cidr" {}
variable "env" {}
variable "subnets" {}
variable "vpc_tags" {}
variable "azs" {}
variable "account_id" {}
variable "default_vpc_id" {}
variable "default_vpc_cidr" {}
variable "default_vpc_rt" {}
variable "bastion_cidr" {}

#the below variables are used in app module
variable "backend" {}