# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "cloudcart-rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "cloudcart-rds-subnets"
  }
}

# RDS Instance
resource "aws_db_instance" "db" {
  identifier             = "cloudcart-db"
  engine                 = var.db_engine # e.g., "postgres"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  username               = var.db_username
  password               = var.db_password # must be >= 8 chars
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
  multi_az               = false
  port                   = var.db_port

  tags = {
    Name = "cloudcart-rds"
  }
}
