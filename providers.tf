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
