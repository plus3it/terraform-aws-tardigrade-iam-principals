provider aws {
  region = "us-east-1"
}

module "policies" {
  source = "../../modules/policies/"

  providers = {
    aws = aws
  }

  policies = [for policy in local.policies : merge(local.policy_base, policy)]
}

module "create_groups" {
  source = "../../modules/groups/"

  providers = {
    aws = aws
  }

  policy_arns = [for policy in module.policies.policies : policy.arn]
  groups      = [for group in local.groups : merge(local.group_base, group)]
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

  policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/tardigrade-alpha-${local.test_id}",
    "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/tardigrade/tardigrade-beta-${local.test_id}",
  ]

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

  policy_base = {
    path          = null
    description   = null
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/"
    ]
  }

  template_vars_base = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  policies = [
    {
      description = "test"
      name        = "tardigrade-alpha-${local.test_id}"
      template    = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
      path     = "/tardigrade/"
    },
  ]

  group_base = {
    inline_policies = []
    path            = null
    policy_arns     = []
    user_names      = []
  }

  groups = [
    {
      name            = "tardigrade-group-alpha-${local.test_id}"
      policy_arns     = local.policy_arns
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
      path            = "/tardigrade/alpha/"
    },
    {
      name            = "tardigrade-group-beta-${local.test_id}"
      policy_arns     = local.policy_arns
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name        = "tardigrade-group-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name            = "tardigrade-group-delta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name = "tardigrade-group-epsilon-${local.test_id}"
    },
  ]
}

output "create_groups" {
  value = module.create_groups
}
