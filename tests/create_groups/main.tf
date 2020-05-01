provider aws {
  region = "us-east-1"
}

module "create_groups" {
  source = "../../modules/groups/"

  providers = {
    aws = aws
  }

  groups          = [for group in local.groups : merge(local.group_base, group)]
  inline_policies = local.group_inline_policies
  policy_arns     = local.policy_arns
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

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

locals {
  test_id = length(data.terraform_remote_state.prereq.outputs) > 0 ? data.terraform_remote_state.prereq.outputs.random_string.result : ""

  policy_arns = length(data.terraform_remote_state.prereq.outputs) > 0 ? [for policy in data.terraform_remote_state.prereq.outputs.policies : policy.arn] : []

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

  inline_policies = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
    },
  ]

  group_base = {
    inline_policy_names = []
    path                = null
    policy_arns         = []
    user_names          = []
  }

  group_inline_policies = [
    {
      name            = "tardigrade-group-alpha-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name            = "tardigrade-group-beta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name            = "tardigrade-group-delta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
  ]

  groups = [
    {
      name                = "tardigrade-group-alpha-${local.test_id}"
      policy_arns         = local.policy_arns
      inline_policy_names = local.inline_policies[*].name
      path                = "/tardigrade/alpha/"
    },
    {
      name                = "tardigrade-group-beta-${local.test_id}"
      policy_arns         = local.policy_arns
      inline_policy_names = local.inline_policies[*].name
    },
    {
      name        = "tardigrade-group-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name                = "tardigrade-group-delta-${local.test_id}"
      inline_policy_names = local.inline_policies[*].name
    },
    {
      name = "tardigrade-group-epsilon-${local.test_id}"
    },
  ]
}

output "create_groups" {
  value = module.create_groups
}
