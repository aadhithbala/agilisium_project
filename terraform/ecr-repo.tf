# resource "aws_ecr_repository" "todo-app" {
#   name                 = "todo-app"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = false
#   }
# }


#Lifecycle policy to keep the private repo size within 500MB
resource "aws_ecr_lifecycle_policy" "todo_app_policy" {
  repository = aws_ecr_repository.todo-app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 3 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
