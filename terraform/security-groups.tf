# # SG for ALB
# resource "aws_security_group" "todo_alb_access_sg" {
#   name        = "todo-alb-access-sg"
#   description = "Security group for Todo Application Load Balancer"
#   vpc_id      = data.aws_vpc.default.id

#   # Inbound access for HTTP 
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "todo-alb-access-sg"
#   }
# }

# SG for dummy application 
resource "aws_security_group" "todo_app_access_sg" {
  name        = "todo-app-access-sg"
  description = "Security group for Todo application"
  vpc_id      = data.aws_vpc.default.id

  # Inbound rule for port 8080, allowing only the ALB security group
  ingress {
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    #security_groups          = [aws_security_group.todo_alb_access_sg.id]
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