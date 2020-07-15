provider aws {
  region = "us-east-1"
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  policy_base = {
    path        = null
    description = null
  }

  policy_document_base = {
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../../templates/"
    ]
  }

  template_vars_base = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  policies = [
    {
      name = "tardigrade-alpha-create-groups-test"
    },
    {
      name = "tardigrade-beta-create-groups-test"
      path = "/tardigrade/"
    },
  ]

  policy_documents = [
    {
      name     = "tardigrade-alpha-create-groups-test"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-create-groups-test"
      template = "policies/template.json"
    },
  ]
}

module "policies" {
  source = "../../../modules/policies/"

  providers = {
    aws = aws
  }

  policies         = [for policy in local.policies : merge(local.policy_base, policy)]
  policy_documents = [for policy_document in local.policy_documents : merge(local.policy_document_base, policy_document)]
  policy_names     = local.policies[*].name
}

output "policies" {
  value = module.policies.policies
}

output "random_string" {
  value = random_string.this
}
