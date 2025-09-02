# Create ECR Repository
resource "aws_ecr_repository" "frontend" {
  name                 = "movie-frontend"
  image_tag_mutability = "MUTABLE"
}
resource "aws_ecr_repository" "backend" {
  name                 = "movie-backend"
  image_tag_mutability = "MUTABLE"
}

# ECS Fargate Cluster
resource "aws_ecs_cluster" "movie_cluster" {
  name = "movie-cluster"
}