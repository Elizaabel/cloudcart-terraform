variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-2"
}

variable "docker_image" {
  description = "Docker image for the CloudCart application"
  type        = string
  default     = "yourdockerhub/cloudcart:latest"
}

variable "instance_type" {
  description = "EC2 instance type for the application"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.2"
}

variable "db_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "cloudcartdb"
}

variable "db_username" {
  description = "Master username for the RDS database"
  type        = string
  default     = "cloudcart"
}

variable "db_password" {
  description = "Master password for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port number for the database"
  type        = number
  default     = 5432
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN for notifications (optional)"
  type        = string
  default     = ""
}
