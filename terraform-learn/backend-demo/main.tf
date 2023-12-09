#backend config details are present in the respective environment folders, which will be invoked while giving terraform init as -backend-config=...tfvars file
terraform {
  backend "s3" {
  }
}

module "ec2-create" {
  source = "./module_ec2"
  component = var.component
  env = var.env
}
#resource "null_resource" "nulling" {
#  provisioner "local-exec" {
#    command = "ls -ltr | wc"
#  }
#}
