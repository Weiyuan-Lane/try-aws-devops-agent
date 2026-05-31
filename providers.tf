# See provider documentation at https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  alias = "devops_agent_deployment"
  region = var.devops_agent_aws_region
}

# See provider documentation at https://registry.terraform.io/providers/hashicorp/awscc/latest/docs
provider "awscc" {
  alias = "devops_agent_deployment"
  region = var.devops_agent_aws_region
}

# Defaults - which could be in your code so you don't have to copy this
provider "aws" {
  region = "us-east-1"
}
provider "awscc" {
  region = "us-east-1"
}
