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

  role_base = {
    policy_arns           = []
    inline_policy_names   = []
    description           = null
    force_detach_policies = null
    instance_profile      = null
    max_session_duration  = null
    path                  = null
    permissions_boundary  = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/tardigrade-alpha-${local.test_id}"
    tags                  = {}
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

  assume_role_policies = [
    for role in local.roles : {
      name           = role.name
      template       = "trusts/template.json"
      template_paths = ["${path.module}/../templates/"]
      template_vars  = local.template_vars_base
    }
  ]

  role_inline_policies = [
    {
      name            = "tardigrade-role-alpha-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, local.policy_document_base, policy)]
    },
    {
      name            = "tardigrade-role-beta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, local.policy_document_base, policy)]
    },
    {
      name            = "tardigrade-role-delta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, local.policy_document_base, policy)]
    },
  ]

  roles = [
    {
      name                  = "tardigrade-role-alpha-${local.test_id}"
      policy_arns           = local.policy_arns
      inline_policy_names   = local.inline_policies[*].name
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
      name                 = "tardigrade-role-beta-${local.test_id}"
      policy_arns          = local.policy_arns
      inline_policy_names  = local.inline_policies[*].name
      permissions_boundary = null
    },
    {
      name        = "tardigrade-role-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name                = "tardigrade-role-delta-${local.test_id}"
      inline_policy_names = local.inline_policies[*].name
    },
    {
      name = "tardigrade-role-epsilon-${local.test_id}"
    },
    {
      name             = "tardigrade-role-phi-${local.test_id}"
      instance_profile = true
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

module "create_roles" {
  source = "../../modules/roles/"

  providers = {
    aws = aws
  }

  # To create the managed policies in the same config, from the `policies` module,
  # need to construct the ARNs manually in `roles.policy_arns` and pass the ARN
  # outputs from the module `policies` as `policy_arns`. This is because `roles.policy_arns`
  # is used in the for_each logic and passing the `policies` module output directly
  # will generate an error:
  #  > The "for_each" value depends on resource attributes that cannot be determined
  #  > until apply, so Terraform cannot predict how many instances will be created.
  #  > To work around this, use the -target argument to first apply only the
  #  > resources that the for_each depends on.

  assume_role_policies = local.assume_role_policies
  inline_policies      = local.role_inline_policies
  policy_arns          = [for policy in module.policies.policies : policy.arn]
  roles                = [for role in local.roles : merge(local.role_base, role)]

  tags = {
    Test = "true"
  }
}

output "policies" {
  value = module.policies
}

output "create_roles" {
  value = module.create_roles
}
