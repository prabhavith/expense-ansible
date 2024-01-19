resource "aws_security_group" "lt-sg" {
  name        = "${var.component}-${var.env}-lt-SG"
  description = "${var.component}-${var.env}-lt-SG"
  vpc_id      = var.vpc_id

  ingress {
    description      = "connection to ${var.component}"
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "tcp"
    cidr_blocks      = var.subnets
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

  tags = merge(var.app_tags , {Name = "${var.component}-${var.env}-lt-SG"})
}

resource "aws_launch_template" "app-lt" {
  name_prefix   = "${var.env}-${var.component}"
  image_id      = data.aws_ami.main.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.lt-sg.id]
  user_data = base64encode(templatefile("${path.module}/userdata.sh", { component = var.component }))
  tags = merge(var.app_tags , { Name = "${var.env}-app-lt"})
  iam_instance_profile {
    name = aws_iam_instance_profile.main.name
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = "true"
      encrypted = "true"
      kms_key_id = var.kms_arn
      volume_type = "gp3"
      volume_size = "10"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  desired_capacity   = var.min_count
  max_size           = var.max_count
  min_size           = var.min_count
  vpc_zone_identifier = [var.sub_ids[0], var.sub_ids[1]]
  launch_template {
    id      = aws_launch_template.app-lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.main.arn]
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.component}-${var.env}"
  }
  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = "Dev"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.component}-${var.env}-lb-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}