resource "aws_ecr_repository" "node_app_ecr" {
  name  = "node-app-ecr-repo-${var.environment}"
}