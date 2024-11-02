# RDS MYSQL Instance

resource "aws_db_instance" "todo_app_db" {
  identifier        = "todo-app-db"
  engine            = "mysql"
  engine_version    = "8.0.39"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2" #Use gp2 storage to stay within freetier

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.todo_db_access_sg.id]

  skip_final_snapshot = true
  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 0 # Disable automated backups to stay in free tier

  performance_insights_enabled = false

  tags = {
    Name = "todo-app-db"
  }
}