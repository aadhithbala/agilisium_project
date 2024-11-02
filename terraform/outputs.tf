#RDS DB endpoint and name

output "db_host" {
  value = aws_db_instance.todo_app_db.endpoint
}

output "db_name" {
  value = aws_db_instance.todo_app_db.db_name
}


#ECR Repo URL
output "ecr_repository_url" {
  value = aws_ecr_repository.todo-app.repository_url
}