locals {
  name_prefix = var.name_prefix

  common_tags = merge(
    {
      Module = "test-agent-serverless-setup"
    },
    var.tags,
  )
}
