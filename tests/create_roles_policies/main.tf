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
    path        = null
    description = null
  }

  role_base = {
    assume_role_policy    = "trusts/template.json"
    policy_arns           = []
    inline_policies       = []
    description           = null
    force_detach_policies = null
    max_session_duration  = null
    path                  = null
    permissions_boundary  = null
    tags                  = {}
  }

  policies = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
      path     = "/tardigrade/"
    },
  ]

  roles = [
    {
      name                  = "tardigrade-role-alpha-${local.test_id}"
      policy_arns           = local.policy_arns
      inline_policies       = local.inline_policies
      description           = "Managed by Terraform - Tardigrade test policy"
      force_detach_policies = false
      max_session_duration  = 3600
      path                  = "/tardigrade/alpha/"
      permissions_boundary  = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/tardigrade/tardigrade-beta-${local.test_id}"
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name            = "tardigrade-role-beta-${local.test_id}"
      policy_arns     = local.policy_arns
      inline_policies = local.inline_policies
    },
    {
      name        = "tardigrade-role-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name            = "tardigrade-role-delta-${local.test_id}"
      inline_policies = local.inline_policies
    },
    {
      name = "tardigrade-role-epsilon-${local.test_id}"
    },
  ]
}

module "policies" {
  source = "../../modules/policies/"
  providers = {
    aws = aws
  }

  template_paths = ["${path.module}/../templates/"]
  template_vars = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  policies = [for policy in local.policies : merge(local.policy_base, policy)]
}

module "create_roles" {
  source = "../../modules/roles/"
  providers = {
    aws = aws
  }

  # To create the managed policies in the same config, from the `policies` module,
  # need to construct the ARNs manually in `roles.policy_arns` and pass the ARN
  # outputs from the module `policies` as `dependencies`. This is because `roles.policy_arns`
  # is used in the for_each logic and passing the `policies` module output directly
  # will generate an error:
  #  > The "for_each" value depends on resource attributes that cannot be determined
  #  > until apply, so Terraform cannot predict how many instances will be created.
  #  > To work around this, use the -target argument to first apply only the
  #  > resources that the for_each depends on.

  dependencies = [for policy in module.policies.policies : policy.arn]

  template_paths = ["${path.module}/../templates/"]
  template_vars = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  description           = "Managed by Terraform"
  force_detach_policies = true
  max_session_duration  = 7200
  path                  = "/tardigrade/"
  permissions_boundary  = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/tardigrade-alpha-${local.test_id}"
  tags = {
    Test = "true"
  }

  roles = [for role in local.roles : merge(local.role_base, role)]
}

output "create_roles" {
  value = module.create_roles
}
