# AWS DevOps Agent Resources

# Wait for IAM roles to propagate before creating the Agent Space
resource "time_sleep" "devops_agent_deployment_wait_for_iam_propagation" {
  depends_on = [
    aws_iam_role.devops_agent_space,
    aws_iam_role_policy_attachment.devops_agent_space_access,
    aws_iam_role_policy_attachment.devops_agent_space_access_regional,
    aws_iam_role_policy_attachment.devops_agent_space_access_supplement,
    aws_iam_role_policy.devops_agent_space_inline,
    aws_iam_role.devops_agent_space_webapp_admin,
    aws_iam_role_policy_attachment.devops_agent_space_webapp_admin_access
  ]

  create_duration = "30s"
}

# Create the Agent Space with WebApp Admin
resource "awscc_devopsagent_agent_space" "main" {
  name        = var.devops_agent_space_name
  description = var.devops_agent_space_description

  operator_app = {
    iam = {
      operator_app_role_arn = aws_iam_role.devops_agent_space_webapp_admin.arn
    }
  }

  depends_on = [
    time_sleep.devops_agent_deployment_wait_for_iam_propagation
  ]
}

# Associate to the AWS account
resource "awscc_devopsagent_association" "aws_account" {
  agent_space_id = awscc_devopsagent_agent_space.main.id
  service_id     = "aws"

  configuration = {
    aws = {
      assumable_role_arn = aws_iam_role.devops_agent_space.arn
      account_id         = data.aws_caller_identity.devops_agent_deployment.account_id
      account_type       = "monitor"
      resources          = []
    }
  }

  depends_on = [
    awscc_devopsagent_agent_space.main
  ]
}
