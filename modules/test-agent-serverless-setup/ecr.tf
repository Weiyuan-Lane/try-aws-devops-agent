resource "aws_ecr_repository" "fargate_app" {
  name                 = "${local.name_prefix}-fargate-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = local.common_tags
}

resource "null_resource" "fargate_image" {
  triggers = {
    dockerfile_hash = filesha256("${path.module}/fargate-app/Dockerfile")
    app_hash        = filesha256("${path.module}/fargate-app/app.py")
    repository_url  = aws_ecr_repository.fargate_app.repository_url
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -euo pipefail
      REPO="${aws_ecr_repository.fargate_app.repository_url}"
      TAG="latest"
      REGION="${data.aws_region.current.name}"

      aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "${split("/", aws_ecr_repository.fargate_app.repository_url)[0]}"
      docker build -t "$REPO:$TAG" "${path.module}/fargate-app"
      docker push "$REPO:$TAG"
    EOT
  }

  depends_on = [aws_ecr_repository.fargate_app]
}
