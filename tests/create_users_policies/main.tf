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

  user_base = {
    policy_arns          = []
    inline_policy_names  = []
    access_keys          = []
    force_destroy        = null
    path                 = null
    permissions_boundary = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/tardigrade-alpha-${local.test_id}"
    tags                 = {}
  }

  policies = [
    {
      description = "test"
      name        = "tardigrade-alpha-${local.test_id}"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      path     = "/tardigrade/"
    },
  ]

  policy_documents = [
    {
      name        = "tardigrade-alpha-${local.test_id}"
      template    = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
    },
  ]

  user_inline_policies = [
    {
      name            = "tardigrade-user-alpha-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, local.policy_document_base, policy)]
    },
    {
      name            = "tardigrade-user-beta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, local.policy_document_base, policy)]
    },
    {
      name            = "tardigrade-user-delta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, local.policy_document_base, policy)]
    },
  ]

  users = [
    {
      name                 = "tardigrade-user-alpha-${local.test_id}"
      policy_arns          = local.policy_arns
      inline_policy_names  = local.inline_policies[*].name
      force_destroy        = false
      path                 = "/tardigrade/alpha/"
      permissions_boundary = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/tardigrade/tardigrade-beta-${local.test_id}"
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

module "policies" {
  source = "../../modules/policies/"

  providers = {
    aws = aws
  }

  policies     = [for policy in local.policies : merge(local.policy_base, policy)]
  policy_documents = [for policy_document in local.policy_documents : merge(local.policy_document_base, policy_document)]
  policy_names = local.policies[*].name
}

module "create_users" {
  source = "../../modules/users/"

  providers = {
    aws = aws
  }

  # To create the managed policies in the same config, from the `policies` module,
  # need to construct the ARNs manually in `users.policy_arns` and pass the ARN
  # outputs from the module `policies` as `policy_arns`. This is because `users.policy_arns`
  # is used in the for_each logic and passing the `policies` module output directly
  # will generate an error:
  #  > The "for_each" value depends on resource attributes that cannot be determined
  #  > until apply, so Terraform cannot predict how many instances will be created.
  #  > To work around this, use the -target argument to first apply only the
  #  > resources that the for_each depends on.

  inline_policies = local.user_inline_policies
  policy_arns     = [for policy in module.policies.policies : policy.arn]
  users           = [for user in local.users : merge(local.user_base, user)]

  tags = {
    Test = "true"
  }
}

output "create_users" {
  value = module.create_users
}
