resource "aws_ssm_parameter" "db_host" {
  name        = "DB_HOST"
  description = "domain address of db server"
  type        = "String"
  value       = var.db_ip
}

resource "aws_ssm_parameter" "proxy" {
  name        = "nginx-proxy"
  description = "backend server alb address"
  type        = "String"
  value       = var.app_alb
}