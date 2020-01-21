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

  policy_arn_base = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy"
  policy_arns = [
    "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}",
    "${local.policy_arn_base}/tardigrade/tardigrade-beta-${local.test_id}",
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

  managed_policies = [
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
    instance_profile      = null
    max_session_duration  = null
    path                  = null
    permissions_boundary  = "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}"
    tags                  = {}
  }

  user_base = {
    policy_arns          = []
    inline_policies      = []
    access_keys          = []
    force_destroy        = null
    path                 = null
    permissions_boundary = "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}"
    tags                 = {}
  }

  roles = [
    {
      name                  = "tardigrade-role-alpha-${local.test_id}"
      policy_arns           = local.policy_arns
      inline_policies       = local.inline_policies
      description           = "Managed by Terraform - Tardigrade test policy"
      force_detach_policies = false
      max_session_duration  = 3600
      path                  = "/tardigrade/alpha/"
      permissions_boundary  = "${local.policy_arn_base}/tardigrade/tardigrade-beta-${local.test_id}"
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
    {
      name             = "tardigrade-role-phi-${local.test_id}"
      instance_profile = true
    },
  ]

  users = [
    {
      name                 = "tardigrade-user-alpha-${local.test_id}"
      policy_arns          = local.policy_arns
      inline_policies      = local.inline_policies
      access_keys          = [for access_key in local.access_keys : merge(local.access_key_base, access_key)]
      force_destroy        = false
      path                 = "/tardigrade/alpha/"
      permissions_boundary = "${local.policy_arn_base}/tardigrade/tardigrade-beta-${local.test_id}"
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name            = "tardigrade-user-beta-${local.test_id}"
      policy_arns     = local.policy_arns
      inline_policies = local.inline_policies
    },
    {
      name        = "tardigrade-user-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name            = "tardigrade-user-delta-${local.test_id}"
      inline_policies = local.inline_policies
    },
    {
      name = "tardigrade-user-epsilon-${local.test_id}"
    },
  ]
}

module "create_all" {
  source = "../../"

  create_policies = true
  create_roles    = true
  create_users    = true

  policies = [for policy in local.managed_policies : merge(local.policy_base, policy)]
  roles    = [for role in local.roles : merge(local.role_base, role)]
  users    = [for user in local.users : merge(local.user_base, user)]

  template_paths = ["${path.module}/../templates/"]
  template_vars = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  tags = {
    Test = "true"
  }
}

output "create_all" {
  value = module.create_all
}
