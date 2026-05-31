
# AWS DevOps Agent Resources

# Create a random suffix to ensure unique role names across deployments
resource "random_id" "devops_agent_deployment_suffix" {
  byte_length = 4
}

locals {
  devops_agent_space_name_slug = replace(lower(var.devops_agent_space_name), " ", "-")
}

# Get the relevant AWS account and region information
data "aws_caller_identity" "devops_agent_deployment" {}
data "aws_region" "devops_agent_deployment" {}

###############################################################################
# Role 1 - DevOps Agent Space Role                                            #
###############################################################################

# Trust policy for DevOps Agent Space Role
data "aws_iam_policy_document" "devops_agent_space_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["aidevops.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.devops_agent_deployment.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:aidevops:${data.aws_region.devops_agent_deployment.name}:${data.aws_caller_identity.devops_agent_deployment.account_id}:agentspace/*"]
    }
  }
}

# DevOps Agent Space Role
resource "aws_iam_role" "devops_agent_space" {
  name               = "DevOpsAgentRole-AgentSpace-${local.devops_agent_space_name_slug}-${random_id.devops_agent_deployment_suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.devops_agent_space_trust.json
  tags               = var.devops_agent_space_tags
}

# Attach AIDevOpsAgentAccessPolicy managed policy to Agent Space role - Useful if no restricted access is needed
# resource "aws_iam_role_policy_attachment" "devops_agent_space_access" {
#   role       = aws_iam_role.devops_agent_space.name
#   policy_arn = "arn:aws:iam::aws:policy/AIDevOpsAgentAccessPolicy"
# }

# Singapore-scoped variant of AIDevOpsAgentAccessPolicy
data "aws_iam_policy_document" "devops_agent_space_access" {
  statement {
    sid       = "AIOPSServiceAccessSingapore"
    effect    = "Allow"
    actions   = local.devops_agent_space_regional_action_chunks[0]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = ["ap-southeast-1"]
    }
  }
}

data "aws_iam_policy_document" "devops_agent_space_access_supplement" {
  statement {
    sid    = "AIOPSGlobalServiceAccess"
    effect = "Allow"
    actions = [
      "acm:GetAccountConfiguration",
      "aidevops:GetKnowledgeItem",
      "aidevops:ListKnowledgeItems",
      "budgets:Describe*",
      "budgets:List*",
      "ce:Describe*",
      "ce:Get*",
      "ce:List*",
      "cloudfront:Describe*",
      "cloudfront:GetCachePolicy",
      "cloudfront:GetCloudFrontOriginAccessIdentity",
      "cloudfront:GetContinuousDeploymentPolicy",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:GetFunction",
      "cloudfront:GetKeyGroup",
      "cloudfront:GetMonitoringSubscription",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:GetOriginRequestPolicy",
      "cloudfront:GetPublicKey",
      "cloudfront:GetRealtimeLogConfig",
      "cloudfront:GetResponseHeadersPolicy",
      "cloudfront:List*",
      "globalaccelerator:Describe*",
      "globalaccelerator:List*",
      "health:DescribeEventDetails",
      "health:DescribeEvents",
      "iam:GetGroup",
      "iam:GetGroupPolicy",
      "iam:GetInstanceProfile",
      "iam:GetLoginProfile",
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetSAMLProvider",
      "iam:GetServerCertificate",
      "iam:GetServiceLinkedRoleDeletionStatus",
      "iam:GetUser",
      "iam:GetUserPolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListOpenIDConnectProviders",
      "iam:ListRolePolicies",
      "iam:ListRoles",
      "iam:ListServerCertificates",
      "iam:ListVirtualMFADevices",
      "identitystore:DescribeGroup",
      "identitystore:DescribeGroupMembership",
      "identitystore:ListGroupMemberships",
      "identitystore:ListGroups",
      "organizations:Describe*",
      "organizations:List*",
      "resource-explorer-2:GetDefaultView",
      "resource-explorer-2:GetIndex",
      "resource-explorer-2:GetView",
      "resource-explorer-2:List*",
      "resource-explorer-2:Search",
      "route53-recovery-control-config:Describe*",
      "route53-recovery-control-config:List*",
      "route53-recovery-readiness:GetCell",
      "route53-recovery-readiness:GetReadinessCheck",
      "route53-recovery-readiness:GetRecoveryGroup",
      "route53-recovery-readiness:GetResourceSet",
      "route53-recovery-readiness:List*",
      "route53:GetDNSSEC",
      "route53:GetHealthCheck",
      "route53:GetHealthCheckStatus",
      "route53:GetHostedZone",
      "route53:List*",
      "route53profiles:GetProfile",
      "route53profiles:GetProfileAssociation",
      "route53profiles:GetProfileResourceAssociation",
      "route53profiles:List*",
      "support:CreateCase",
      "support:DescribeCases",
      "tag:GetResources",
    ]
    resources = ["*"]
  }

  # A small gotcha as S3 uses the global endpoint - you need to tighten it further yourself by scoping "resources" to your specific S3 bucket(s)
  statement {
    sid    = "AIOPSS3ServiceAccess"
    effect = "Allow"
    actions = [
      "s3:GetAccessGrant",
      "s3:GetAccessGrantsInstance",
      "s3:GetAccessGrantsLocation",
      "s3:GetAccessPoint",
      "s3:GetAccessPointConfigurationForObjectLambda",
      "s3:GetAccessPointForObjectLambda",
      "s3:GetAccessPointPolicy",
      "s3:GetAccessPointPolicyForObjectLambda",
      "s3:GetAccessPointPolicyStatusForObjectLambda",
      "s3:GetBucketAbac",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketMetadataTableConfiguration",
      "s3:GetBucketNotification",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:GetBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetMultiRegionAccessPoint",
      "s3:GetMultiRegionAccessPointPolicy",
      "s3:GetMultiRegionAccessPointPolicyStatus",
      "s3:GetReplicationConfiguration",
      "s3:GetStorageLensConfiguration",
      "s3:GetStorageLensConfigurationTagging",
      "s3:GetStorageLensGroup",
      "s3:ListAllMyBuckets",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AIOPSAPIGatewayAccess"
    effect = "Allow"
    actions = [
      "apigateway:GET",
    ]
    resources = [
      "arn:aws:apigateway:ap-southeast-1::/restapis",
      "arn:aws:apigateway:ap-southeast-1::/restapis/*",
      "arn:aws:apigateway:ap-southeast-1::/restapis/*/deployments",
      "arn:aws:apigateway:ap-southeast-1::/restapis/*/deployments/*",
      "arn:aws:apigateway:ap-southeast-1::/restapis/*/resources/*/methods/*/integrations",
      "arn:aws:apigateway:ap-southeast-1::/restapis/*/resources/*/methods/*/integrations/*",
      "arn:aws:apigateway:ap-southeast-1::/restapis/*/stages",
      "arn:aws:apigateway:ap-southeast-1::/restapis/*/stages/*",
      "arn:aws:apigateway:ap-southeast-1::/apis",
      "arn:aws:apigateway:ap-southeast-1::/apis/*",
      "arn:aws:apigateway:ap-southeast-1::/apis/*/deployments",
      "arn:aws:apigateway:ap-southeast-1::/apis/*/deployments/*",
      "arn:aws:apigateway:ap-southeast-1::/apis/*/integrations",
      "arn:aws:apigateway:ap-southeast-1::/apis/*/integrations/*",
      "arn:aws:apigateway:ap-southeast-1::/apis/*/stages",
      "arn:aws:apigateway:ap-southeast-1::/apis/*/stages/*",
      "arn:aws:apigateway:ap-southeast-1::/domainnames/*",
    ]
  }
}

data "aws_iam_policy_document" "devops_agent_space_access_regional" {
  count = max(length(local.devops_agent_space_regional_action_chunks) - 1, 0)

  statement {
    sid       = "AIOPSServiceAccessSingapore${count.index + 2}"
    effect    = "Allow"
    actions   = local.devops_agent_space_regional_action_chunks[count.index + 1]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = ["ap-southeast-1"]
    }
  }
}

# Inline policies share a 10,240-byte role limit, so we use customer-managed policies.
resource "aws_iam_policy" "devops_agent_space_access" {
  name        = "AIDevOpsAgentAccessPolicy-${random_id.devops_agent_deployment_suffix.hex}"
  description = "Singapore-scoped read access for AWS DevOps Agent (regional part 1)"
  policy      = data.aws_iam_policy_document.devops_agent_space_access.json
  tags        = var.devops_agent_space_tags
}

resource "aws_iam_role_policy_attachment" "devops_agent_space_access" {
  role       = aws_iam_role.devops_agent_space.name
  policy_arn = aws_iam_policy.devops_agent_space_access.arn
}

resource "aws_iam_policy" "devops_agent_space_access_regional" {
  count    = max(length(local.devops_agent_space_regional_action_chunks) - 1, 0)

  name        = "AIDevOpsAgentAccessPolicy-Regional${count.index + 2}-${random_id.devops_agent_deployment_suffix.hex}"
  description = "Singapore-scoped read access for AWS DevOps Agent (regional part ${count.index + 2})"
  policy      = data.aws_iam_policy_document.devops_agent_space_access_regional[count.index].json
  tags        = var.devops_agent_space_tags
}

resource "aws_iam_role_policy_attachment" "devops_agent_space_access_regional" {
  count      = max(length(local.devops_agent_space_regional_action_chunks) - 1, 0)
  role       = aws_iam_role.devops_agent_space.name
  policy_arn = aws_iam_policy.devops_agent_space_access_regional[count.index].arn
}

resource "aws_iam_policy" "devops_agent_space_access_supplement" {
  name        = "AIDevOpsAgentAccessPolicy-Supplement-${random_id.devops_agent_deployment_suffix.hex}"
  description = "Global, S3, and API Gateway access for AWS DevOps Agent"
  policy      = data.aws_iam_policy_document.devops_agent_space_access_supplement.json
  tags        = var.devops_agent_space_tags
}

# Final inline policy for creating Resource Explorer service-linked role (within limit)
resource "aws_iam_role_policy_attachment" "devops_agent_space_access_supplement" {
  role       = aws_iam_role.devops_agent_space.name
  policy_arn = aws_iam_policy.devops_agent_space_access_supplement.arn
}

data "aws_iam_policy_document" "devops_agent_space_inline" {
  statement {
    sid    = "AllowCreateServiceLinkedRoles"
    effect = "Allow"

    actions = [
      "iam:CreateServiceLinkedRole"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.devops_agent_deployment.account_id}:role/aws-service-role/resource-explorer-2.amazonaws.com/AWSServiceRoleForResourceExplorer"
    ]
  }
}

resource "aws_iam_role_policy" "devops_agent_space_inline" {
  name     = "AllowCreateServiceLinkedRoles"
  role     = aws_iam_role.devops_agent_space.id
  policy   = data.aws_iam_policy_document.devops_agent_space_inline.json
}

###############################################################################
# Role 2 - DevOps WebApp Admin Role                                           #
###############################################################################

# Trust policy for WebApp Admin Role
data "aws_iam_policy_document" "devops_agent_space_webapp_admin_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["aidevops.amazonaws.com"]
    }

    actions = ["sts:AssumeRole", "sts:TagSession"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.devops_agent_deployment.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:aidevops:${data.aws_region.devops_agent_deployment.name}:${data.aws_caller_identity.devops_agent_deployment.account_id}:agentspace/*"]
    }
  }
}

# DevOps WebApp Admin Role
resource "aws_iam_role" "devops_agent_space_webapp_admin" {
  name               = "DevOpsAgentRole-WebappAdmin-${local.devops_agent_space_name_slug}-${random_id.devops_agent_deployment_suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.devops_agent_space_webapp_admin_trust.json

  tags = var.devops_agent_space_tags
}

# Attach AIDevOpsOperatorAppAccessPolicy managed policy to WebApp Admin role
resource "aws_iam_role_policy_attachment" "devops_agent_space_webapp_admin_access" {
  role       = aws_iam_role.devops_agent_space_webapp_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AIDevOpsOperatorAppAccessPolicy"
}
