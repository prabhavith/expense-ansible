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

  owners = ["973714476881"] # Canonical
}

resource "aws_instance" "server1" {
  ami = data.aws_ami.centos.id
  instance_type = "t2.micro"
  tags = {
    Name = "server1"
  }
}
output "IPs" {
  value = "private ip is ${aws_instance.server1.private_ip}\n and AZ is ${aws_instance.server1.availability_zone}"
}

#variable "null_test" {}
#resource "null_resource" test {
#  triggers = {
#    null = var.null_test
#  }
#  provisioner "local-exec" {
#    command = "ipconfig | findstr IPv6"
#  }
#}
#output "null_out" {
#  value = "Given value is ${null_resource.test.triggers.null}"
#}
#output "null_id" {
#  value = null_resource.test.id
#}