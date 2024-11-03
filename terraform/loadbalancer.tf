resource "aws_lb" "todo_alb" {
  name               = "todo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.todo_alb_access_sg.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Name = "todo-alb"
  }
}

# Target group for ECS service
resource "aws_lb_target_group" "todo_app_tg" {
  name        = "todo-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    path                = "/" # Using the root endpoint, Since i couldn't find the /health endpoint in the application
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "todo-app-tg"
  }
}

# Listener for ALB
resource "aws_lb_listener" "todo_alb_listener" {
  load_balancer_arn = aws_lb.todo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.todo_app_tg.arn
  }
}