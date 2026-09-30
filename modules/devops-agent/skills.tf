data "archive_file" "skill" {
  for_each = local.devops_agent_skills

  type        = "zip"
  source_dir  = each.value.source_dir
  output_path = "${path.module}/build/${each.key}.zip"
  excludes = [
    "README.md",
    "README_zh.md",
    "README_EN.md",
  ]
}

resource "awscc_devopsagent_asset" "skill" {
  for_each = local.devops_agent_skills

  agent_space_id = awscc_devopsagent_agent_space.main.id
  asset_type     = "skill"
  zip            = filebase64(data.archive_file.skill[each.key].output_path)

  # For zip uploads the service reads name/description from SKILL.md frontmatter.
  metadata = jsonencode({
    agent_types = each.value.agent_types
    status      = "ACTIVE"
  })

  depends_on = [
    awscc_devopsagent_agent_space.main
  ]
}
