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

  access_keys = [
    {
      name = "tardigrade-alpha-${local.test_id}"
    },
    {
      name = "tardigrade-beta-${local.test_id}"
    },
  ]

  access_key_base = {
    pgp_key = null
    status  = null
  }

  user_base = {
    policy_arns          = []
    inline_policy_names  = []
    access_keys          = []
    force_destroy        = null
    path                 = null
    permissions_boundary = data.terraform_remote_state.prereq.outputs.policies["tardigrade-alpha-create-users-test"].arn
    tags                 = {}
  }

  user_inline_policies = [
    {
      name            = "tardigrade-user-alpha-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name            = "tardigrade-user-beta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name            = "tardigrade-user-delta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
  ]

  users = [
    {
      name                 = "tardigrade-user-alpha-${local.test_id}"
      policy_arns          = local.policy_arns
      inline_policy_names  = local.inline_policies[*].name
      access_keys          = [for access_key in local.access_keys : merge(local.access_key_base, access_key)]
      force_destroy        = false
      path                 = "/tardigrade/alpha/"
      permissions_boundary = data.terraform_remote_state.prereq.outputs.policies["tardigrade-beta-create-users-test"].arn
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name                 = "tardigrade-user-beta-${local.test_id}"
      policy_arns          = local.policy_arns
      inline_policy_names  = local.inline_policies[*].name
      permissions_boundary = null
    },
    {
      name        = "tardigrade-user-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name                = "tardigrade-user-delta-${local.test_id}"
      inline_policy_names = local.inline_policies[*].name
    },
    {
      name = "tardigrade-user-epsilon-${local.test_id}"
    },
  ]
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

module "create_users" {
  source = "../../modules/users/"

  providers = {
    aws = aws
  }

  inline_policies = local.user_inline_policies
  policy_arns     = local.policy_arns
  users           = [for user in local.users : merge(local.user_base, user)]

  tags = {
    Test = "true"
  }
}

output "create_users" {
  value = module.create_users
}
