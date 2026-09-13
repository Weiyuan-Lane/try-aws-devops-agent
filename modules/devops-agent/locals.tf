locals {
  common_tags = merge(
    {
      Module = "devops-agent"
    },
    var.devops_agent_space_tags,
  )

  skills_submodule_root = "${path.module}/sample-skills-for-AWS-Devops-agent"

  skills = {
    eks-resilience-checker-skill-devops = {
      source_dir  = "${local.skills_submodule_root}/eks-resilience-checker-skill-devops"
      agent_types = ["GENERIC"]
    }
    aws-wa-review-skill-devops = {
      source_dir  = "${local.skills_submodule_root}/aws-wa-review-skill-devops"
      agent_types = ["GENERIC"]
    }
  }

  china_management_skills = {
    china-region-multi-account-routing = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/china-region-multi-account-routing"
      agent_types = ["GENERIC"]
    }
    china-incident-triage = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/china-incident-triage"
      agent_types = ["INCIDENT_TRIAGE"]
    }
    china-incident-rca = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/china-incident-rca"
      agent_types = ["INCIDENT_RCA"]
    }
    china-incident-mitigation = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/china-incident-mitigation"
      agent_types = ["INCIDENT_MITIGATION"]
    }
    china-account-prevention-checks = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/china-account-prevention-checks"
      agent_types = ["PREVENTION"]
    }
    cn-partition-arn-routing = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/cn-partition-arn-routing"
      agent_types = ["GENERIC"]
    }
    cross-account-cost-attribution = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/cross-account-cost-attribution"
      agent_types = ["GENERIC"]
    }
    cross-account-inventory-compare = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/cross-account-inventory-compare"
      agent_types = ["GENERIC"]
    }
    cross-account-security-posture-check = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/cross-account-security-posture-check"
      agent_types = ["GENERIC"]
    }
    use-eks-via-call-kubectl = {
      source_dir  = "${local.skills_submodule_root}/devops-agent-cn-management/use-eks-via-call-kubectl"
      agent_types = ["GENERIC"]
    }
  }

  devops_agent_skills = merge(local.skills, local.china_management_skills)
}
