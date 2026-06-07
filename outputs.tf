output "test_agent_lambda_function_url" {
  description = "Lambda Function URL for the test serverless endpoint"
  value       = module.test_agent_serverless_setup.lambda_function_url
}

output "test_agent_fargate_internal_endpoint" {
  description = "Internal ALB endpoint used when proxy=true on the Lambda URL"
  value       = module.test_agent_serverless_setup.fargate_internal_endpoint
}
