# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

# Using the default VPC (Due to freetier) 
data "aws_vpc" "default" {
  default = true
}

# SG for dummy application 
resource "aws_security_group" "todo_app_access_sg" {
  name        = "todo-app-access-sg"
  description = "Security group for Todo application"
  vpc_id      = data.aws_vpc.default.id

  # Inbound rule for port 8080 from all IPv4
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule to all IPv4
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "todo-app-access-sg"
  }
}

# SG for the RDS MYSQL Instance 
resource "aws_security_group" "todo_db_access_sg" {
  name        = "todo-db-access-sg"
  description = "Security group for Todo database"
  vpc_id      = data.aws_vpc.default.id

  # Inbound rule for MySQL (3306) from todo-app security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.todo_app_access_sg.id]
  }

  # Outbound rule to all IPv4
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "todo-db-access-sg"
  }
}

# RDS MYSQL Instance

resource "aws_db_instance" "todo_app_db" {
  identifier        = "todo-app-db"
  engine            = "mysql"
  engine_version    = "8.0.39"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type           = "gp2" #Use gp2 storage to stay within freetier

  db_name  = "todo_app_db"
  username = "admin"
  password = "white123" #TODO: Fix this - Need to figure out how to pass this dynamically

  vpc_security_group_ids = [aws_security_group.todo_db_access_sg.id]
  
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az               = false
  
  backup_retention_period = 0  # Disable automated backups to stay in free tier

  performance_insights_enabled = false
  
  tags = {
    Name = "todo-app-db"
  }
}