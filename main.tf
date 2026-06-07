module "devops_agent" {
  source = "./modules/devops-agent"

  devops_agent_aws_region          = var.devops_agent_aws_region
  devops_agent_space_name          = var.devops_agent_space_name
  devops_agent_space_description   = var.devops_agent_space_description
  devops_agent_space_tags          = var.devops_agent_space_tags

  providers = {
    aws   = aws.devops_agent_deployment
    awscc = awscc.devops_agent_deployment
  }
}

module "test_agent_serverless_setup" {
  source = "./modules/test-agent-serverless-setup"

  name_prefix = var.test_agent_name_prefix
  tags        = var.test_agent_tags

  providers = {
    aws = aws.devops_agent_deployment
  }
}
