provider aws {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

locals {
  policy_base = {
    path          = null
    description   = null
  }

  policy_document_base = {
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/"
    ]
  }

  template_vars_base = {
    account_id    = data.aws_caller_identity.current.account_id
    partition     = data.aws_partition.current.partition
    region        = data.aws_region.current.name
    random_string = random_string.this.result
  }

  policies = [
    {
      name     = "tardigrade-alpha-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    },
    {
      name     = "tardigrade-beta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      path     = "/tardigrade/"
    },
    {
      name        = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    },
    {
      name        = "tardigrade-role-delta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      path        = "/tardigrade/"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    },
  ]

  policy_documents = [
    {
      name     = "tardigrade-alpha-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template = "policies/template.json"
      template_vars = merge(
        local.template_vars_base,
        {
          account_id = "foo"
        }
      )
    },
    {
      name     = "tardigrade-beta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template = "policies/template.json"
    },
    {
      name        = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template    = "policies/template.json"
    },
    {
      name        = "tardigrade-role-delta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template    = "policies/template.json"
    },
  ]
}

module "policies" {
  source = "../../modules/policies/"

  providers = {
    aws = aws
  }

  policies     = [for policy in local.policies : merge(local.policy_base, policy)]
  policy_documents = [for policy_document in local.policy_documents : merge(local.policy_document_base, policy_document)]
  policy_names = local.policies[*].name
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

output "policies" {
  value = module.policies
}
