resource "aws_security_group" "sg-lt" {
  name        = "sg-lt"
  description = "Allow SG for launch template"
  vpc_id      = var.vpc_id

  ingress {
    description      = "app connection to web"
    from_port        = var.backend["app_port"]
    to_port          = var.backend["app_port"]
    protocol         = "tcp"
    cidr_blocks      = var.subnets["backend"]
  }

  ingress {
    description      = "SSH connection"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.bastion_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.app_tags , {Name = "Dev-SG-LT"})
}

resource "aws_launch_template" "app-lt" {
  name_prefix   = "${var.env}-${var.backend["component"]}"
  image_id      = data.aws_ami.main.id
  instance_type = var.backend["instance_type"]
  vpc_security_group_ids = [aws_security_group.sg-lt.id]
  tags = merge(var.app_tags , { Name = "${var.env}-app-lt"  })
}

resource "aws_autoscaling_group" "bar" {
  desired_capacity   = var.backend["min_count"]
  max_size           = var.backend["max_count"]
  min_size           = var.backend["min_count"]

  launch_template {
    id      = aws_launch_template.app-lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.backend["component"]}-${var.env}"
  }
  tag {
    key                 = "Environment"
    propagate_at_launch = True
    value               = "Dev"
  }
}