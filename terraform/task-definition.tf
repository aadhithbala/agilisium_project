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
      image        = #TODO:lVARIABLE
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
          value = #TODO:lVARIABLE
        },
        {
          name  = "DB_NAME"
          value = #TODO:lVARIABLE
        },
        {
          name  = "DB_USER"
          value = #TODO:lVARIABLE
        },
        {
          name  = "DB_PASS"
          value = #TODO:lVARIABLE
        }
      ]
    }
  ])

  tags = {
    Name = "todo-app-task-definition"
  }
}
