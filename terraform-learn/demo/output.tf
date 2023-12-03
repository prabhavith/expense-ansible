output "Instance-id" {
	description = "instance id of demo server"
	value = aws_instance.example-server.id
}

output "primary-IP" {
	description = "public ip of demo server"
	value = aws_instance.example-server.public_ip
}

output "secondary-IP" {
	description = "private ip of demo server"
	value = aws_instance.example-server.private_ip
	sensitive = true
}

