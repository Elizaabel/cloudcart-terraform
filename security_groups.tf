# -------------------------------
# ALB Security Group
# -------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "cloudcart-alb-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow HTTP traffic from anywhere to the ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------
# App Security Group
# -------------------------------
resource "aws_security_group" "app_sg" {
  name        = "cloudcart-app-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow traffic from ALB to app instances"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------
# RDS Security Group
# -------------------------------
resource "aws_security_group" "rds_sg" {
  name        = "cloudcart-rds-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow database traffic only from app instances"

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
