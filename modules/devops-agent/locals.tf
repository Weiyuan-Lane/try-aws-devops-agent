locals {
  common_tags = merge(
    {
      Module = "devops-agent"
    },
    var.devops_agent_space_tags,
  )

  skills_submodule_root = "${path.module}/sample-skills-for-AWS-Devops-agent"

  devops_agent_skills = {
    eks-resilience-checker-skill-devops = {
      source_dir  = "${local.skills_submodule_root}/eks-resilience-checker-skill-devops"
      agent_types = ["GENERIC"]
    }
    aws-wa-review-skill-devops = {
      source_dir  = "${local.skills_submodule_root}/aws-wa-review-skill-devops"
      agent_types = ["GENERIC"]
    }
  }
}
