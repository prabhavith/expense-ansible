resource "aws_instance" "example-server" {
	ami = var.ami-id
	instance_type = var.type
	tags = {
		Name = "demo-server"
	}
	key_name = "My_test login"
}

