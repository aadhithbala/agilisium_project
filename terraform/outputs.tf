#RDS DB endpoint and name

output "db_host" {
  value = aws_db_instance.todo_app_db.address
  sensitive = true
}

output "db_name" {
  value = aws_db_instance.todo_app_db.db_name
  sensitive = true
}

#ECR REPO URL

data "aws_ecr_repository" "todo-app" {
  name = "todo-app"
}

output "ecr_repository_url" {
  value = data.aws_ecr_repository.todo-app.repository_url
}