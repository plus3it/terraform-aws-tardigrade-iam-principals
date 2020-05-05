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

  role_base = {
    description           = null
    force_detach_policies = null
    inline_policy_names   = []
    instance_profile      = null
    max_session_duration  = null
    path                  = null
    permissions_boundary  = data.terraform_remote_state.prereq.outputs.policies["tardigrade-alpha-create-roles-test"].arn
    policy_arns           = []
    tags                  = {}
  }

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
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name            = "tardigrade-role-beta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
    },
    {
      name            = "tardigrade-role-delta-${local.test_id}"
      inline_policies = [for policy in local.inline_policies : merge(local.policy_base, policy)]
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
      permissions_boundary  = data.terraform_remote_state.prereq.outputs.policies["tardigrade-beta-create-roles-test"].arn
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

module "create_roles" {
  source = "../../modules/roles/"

  providers = {
    aws = aws
  }

  assume_role_policies = local.assume_role_policies
  inline_policies      = local.role_inline_policies
  policy_arns          = local.policy_arns
  roles                = [for role in local.roles : merge(local.role_base, role)]

  tags = {
    Test = "true"
  }
}

output "create_roles" {
  value = module.create_roles
}
