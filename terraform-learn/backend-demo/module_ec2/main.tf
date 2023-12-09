#component variable stores map of different components frontend, backend, database. By using for_each we call one by one keys of that map, which is used for iteration.
resource "aws_instance" "testing" {
  for_each = var.component
  ami      =  data.aws_ami.centos.id
  instance_type     = each.value["type"] //each.value is used to call the value of the key invoked by for_each
  tags     = {
    Name = each.value["name"]
    Environment = var.env
  }
}

#to fetch ami details from AWS account. To use the ami id we have to give .id
data "aws_ami" "centos" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["973714476881"] //owner of account
}