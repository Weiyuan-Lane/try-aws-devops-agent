variable "devops_agent_aws_region" {
  description = "AWS region for DevOps Agent deployment"
  type        = string
  default     = "us-east-1"
}

variable "devops_agent_space_name" {
  description = "Name of the AWS DevOps Agent space"
  type        = string
  default     = "AgentSpace"
}

variable "devops_agent_space_description" {
  description = "Description of the AWS DevOps Agent space"
  type        = string
  default     = "DevOps Agent space"
}

variable "devops_agent_space_tags" {
  description = "Tags for the AWS DevOps Agent space"
  type        = map(string)
  default = {
    "Environment" = "Development"
    "Team"        = "DevOps Team"
    "Version"     = "0.0.1"
  }
}

variable "test_agent_name_prefix" {
  description = "Name prefix for test-agent-serverless-setup resources"
  type        = string
  default     = "test-agent-serverless"
}

variable "test_agent_tags" {
  description = "Tags for test-agent-serverless-setup resources"
  type        = map(string)
  default     = {}
}
