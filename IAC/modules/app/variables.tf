variable "env" {}
variable "backend" {
  component = "backend"
  min_count = 1
  max_count = 2
  app_port = 8080
  instance_type = "t2.small"
}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "app_tags" {}
variable "subnets" {}
variable "bastion_cidr" {}