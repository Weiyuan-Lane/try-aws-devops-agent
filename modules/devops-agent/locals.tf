locals {
  common_tags = merge(
    {
      Module = "devops-agent"
    },
    var.devops_agent_space_tags,
  )
}
