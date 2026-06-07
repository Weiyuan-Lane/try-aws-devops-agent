variable "name_prefix" {
  description = "Prefix for resource names in this test setup"
  type        = string
  default     = "test-agent-serverless"
}

variable "tags" {
  description = "Tags applied to supported resources"
  type        = map(string)
  default     = {}
}

variable "fargate_fail_rate" {
  description = "Probability (0-1) that the Fargate endpoint simulates failure and exits"
  type        = number
  default     = 0.2

  validation {
    condition     = var.fargate_fail_rate >= 0 && var.fargate_fail_rate <= 1
    error_message = "fargate_fail_rate must be between 0 and 1."
  }
}

variable "fargate_desired_count" {
  description = "Number of Fargate tasks to run"
  type        = number
  default     = 1
}
