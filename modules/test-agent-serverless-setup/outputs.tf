output "lambda_function_name" {
  description = "Name of the test Lambda function"
  value       = aws_lambda_function.endpoint.function_name
}

output "lambda_function_url" {
  description = "Public Function URL for the Lambda endpoint (?fail=true, ?proxy=true)"
  value       = aws_lambda_function_url.endpoint.function_url
}

output "fargate_internal_endpoint" {
  description = "Internal ALB URL proxied when Lambda is called with proxy=true"
  value       = "http://${aws_lb.internal.dns_name}:8080/"
}

output "ecs_cluster_name" {
  description = "ECS cluster running the Fargate service"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECS service name for the Fargate workload"
  value       = aws_ecs_service.fargate_app.name
}
