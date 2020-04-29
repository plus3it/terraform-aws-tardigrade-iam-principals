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
      path     = "/tardigrade/"
    },
    {
      name        = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template    = "policies/template.json"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    },
    {
      name        = "tardigrade-role-delta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template    = "policies/template.json"
      path        = "/tardigrade/"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    },
  ]
}

module "policies" {
  source = "../../modules/policies/"

  providers = {
    aws = aws
  }

  policies     = [for policy in local.policies : merge(local.policy_base, policy)]
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
