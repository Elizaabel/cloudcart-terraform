# -------------------------------
# AMI Data Source
# -------------------------------
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# -------------------------------
# Application Load Balancer
# -------------------------------
resource "aws_lb" "alb" {
  name               = "cloudcart-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]
}

# -------------------------------
# Target Group
# -------------------------------
resource "aws_lb_target_group" "tg" {
  name     = "cloudcart-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# -------------------------------
# Listener
# -------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# -------------------------------
# User Data Template
# -------------------------------
data "template_file" "user_data" {
  template = file("${path.module}/userdata.tpl")

  vars = {
    docker_image = var.docker_image
    log_group    = "/cloudcart/app"
    aws_region   = var.aws_region
  }
}

# -------------------------------
# Launch Template
# -------------------------------
resource "aws_launch_template" "lt" {
  name_prefix            = "cloudcart-lt-"
  image_id               = data.aws_ami.amazon_linux2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(data.template_file.user_data.rendered)
}

# -------------------------------
# Auto Scaling Group
# -------------------------------
resource "aws_autoscaling_group" "asg" {
  name                = "cloudcart-asg"
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.tg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "cloudcart-app"
    propagate_at_launch = true
  }
}
