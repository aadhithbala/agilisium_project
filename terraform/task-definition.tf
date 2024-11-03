# Task Definition
resource "aws_ecs_task_definition" "todo_app" {
  family                   = "todo-app-task-df"
  requires_compatibilities = ["EC2"]
  network_mode            = "bridge"
  cpu                     = "200"
  memory                  = "512"

  container_definitions = jsonencode([
    {
      name         = "todo-app"
      image        = "${aws_ecr_repository.todo-app.repository_url}:latest"
      essential    = true
      cpu          = 200
      memory       = 512
      memoryReservation = 409

      portMappings = [
        {
          name          = "todo-app-port"
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.todo_app_db.address
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        }
      ]
    }
  ])

  tags = {
    Name = "todo-app-task-definition"
  }
}
