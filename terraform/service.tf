# ECS Service
resource "aws_ecs_service" "todo_app" {
  name            = "todo-app-service"
  cluster         = aws_ecs_cluster.todo_app_cluster.id
  task_definition = "${aws_ecs_task_definition.todo_app.family}:${aws_ecs_task_definition.todo_app.revision}"
  desired_count   = 2
  launch_type     = "EC2"

  # Deployment configuration
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds = 60

  # Capacity provider strategy
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    base             = 1
    weight          = 100
  }
  
  force_new_deployment = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  scheduling_strategy = "REPLICA"

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = {
    Name = "todo-app-service"
  }
}