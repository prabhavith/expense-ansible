output "app_alb" {
  value = aws_lb.main.dns_name
}