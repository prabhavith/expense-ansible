
resource "aws_security_group" "alb-sg" {
  name        = "${var.component}-${var.env}-alb-sg"
  description = "${var.component}-${var.env}-alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "connection from internet to ${var.component}-${var.env}-alb-sg"
    from_port        = var.alb_port
    to_port          = var.alb_port
    protocol         = "tcp"
    cidr_blocks      = var.in_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.alb_tags , {Name = "${var.component}-${var.env}-alb-SG"})
}


resource "aws_lb" "main" {
  name               = "${var.env}-$}${var.component}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.subnets
  tags = merge(var.alb_tags , {Name = "${var.env}-$}${var.component}-ALB"})
}


resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
}