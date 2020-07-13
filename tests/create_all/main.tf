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

/*
resource "random_string" "foo" {
  length  = 6
  upper   = false
  special = false
  number  = false
}
*/

locals {
  test_id = length(data.terraform_remote_state.prereq.outputs) > 0 ? data.terraform_remote_state.prereq.outputs.random_string.result : ""

  policy_arn_base = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy"
  policy_arns = [
    "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}",
    "${local.policy_arn_base}/tardigrade/tardigrade-beta-${local.test_id}",
  ]

  user_names = [
    "tardigrade-user-alpha-${local.test_id}",
    "tardigrade-user-beta-${local.test_id}",
    "tardigrade-user-chi-${local.test_id}",
    "tardigrade-user-delta-${local.test_id}",
    "tardigrade-user-epsilon-${local.test_id}",
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

  inline_policies_base = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
    },
  ]

  inline_policies_merged = [for policy in local.inline_policies_base : merge(
    local.policy_base,
    local.policy_document_base,
    policy
  )]

  managed_policies = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      path     = "/tardigrade/"
    },
  ]

  managed_policy_documents = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
      template_vars = merge(
        local.template_vars_base,
        {
          instance_arns = join(
            "\",\"",
            [
              "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
              "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${random_string.this.result}",
//              "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${random_string.foo.result}",
            ]
          )
        }
      )
    },
  ]

  group_base = {
    inline_policy_names = []
    path                = null
    policy_arns         = []
    user_names          = []
  }

  policy_base = {
    path          = null
    description   = null
  }

  policy_document_base = {
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/",
      "${path.module}/templates/",
    ]
  }

  template_vars_base = {
    account_id    = data.aws_caller_identity.current.account_id
    partition     = data.aws_partition.current.partition
    region        = data.aws_region.current.name
    random_string = random_string.this.result
    instance_arns = join(
      "\",\"",
      [
        "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
      ]
    )
  }

  role_base = {
    policy_arns           = []
    inline_policy_names   = []
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
    inline_policy_names  = []
    access_keys          = []
    force_destroy        = null
    path                 = null
    permissions_boundary = "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}"
    tags                 = {}
  }

  inline_policies = [
    {
      name            = "tardigrade-group-alpha-${local.test_id}"
      type            = "group"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-group-beta-${local.test_id}"
      type            = "group"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-group-delta-${local.test_id}"
      type            = "group"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-role-alpha-${local.test_id}"
      type            = "role"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-role-beta-${local.test_id}"
      type            = "role"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-role-delta-${local.test_id}"
      type            = "role"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-user-alpha-${local.test_id}"
      type            = "user"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-user-beta-${local.test_id}"
      type            = "user"
      inline_policies = local.inline_policies_merged
    },
    {
      name            = "tardigrade-user-delta-${local.test_id}"
      type            = "user"
      inline_policies = local.inline_policies_merged
    },
  ]

  groups = [
    {
      name                = "tardigrade-group-alpha-${local.test_id}"
      inline_policy_names = local.inline_policies_base[*].name
      policy_arns         = local.policy_arns
      path                = "/tardigrade/alpha/"
      user_names          = local.user_names
    },
    {
      name                = "tardigrade-group-beta-${local.test_id}"
      inline_policy_names = local.inline_policies_base[*].name
      policy_arns         = local.policy_arns
      user_names          = ["tardigrade-user-beta-${local.test_id}"]
    },
    {
      name        = "tardigrade-group-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name                = "tardigrade-group-delta-${local.test_id}"
      inline_policy_names = local.inline_policies_base[*].name
    },
    {
      name = "tardigrade-group-epsilon-${local.test_id}"
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

  roles = [
    {
      name                  = "tardigrade-role-alpha-${local.test_id}"
      policy_arns           = local.policy_arns
      inline_policy_names   = local.inline_policies_base[*].name
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
      name                = "tardigrade-role-beta-${local.test_id}"
      policy_arns         = local.policy_arns
      inline_policy_names = local.inline_policies_base[*].name
    },
    {
      name        = "tardigrade-role-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name                = "tardigrade-role-delta-${local.test_id}"
      inline_policy_names = local.inline_policies_base[*].name
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
      inline_policy_names  = local.inline_policies_base[*].name
      access_keys          = [for access_key in local.access_keys : merge(local.access_key_base, access_key)]
      force_destroy        = false
      path                 = "/tardigrade/alpha/"
      permissions_boundary = "${local.policy_arn_base}/tardigrade/tardigrade-beta-${local.test_id}"
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name                = "tardigrade-user-beta-${local.test_id}"
      policy_arns         = local.policy_arns
      inline_policy_names = local.inline_policies_base[*].name
    },
    {
      name        = "tardigrade-user-chi-${local.test_id}"
      policy_arns = local.policy_arns
    },
    {
      name                = "tardigrade-user-delta-${local.test_id}"
      inline_policy_names = local.inline_policies_base[*].name
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

module "create_all" {
  source = "../../"

  create_policies = true
  create_roles    = true
  create_users    = true
  create_groups   = true

  policies         = [for policy in local.managed_policies : merge(local.policy_base, policy)]
  policy_documents = [for policy_document in local.managed_policy_documents : merge(local.policy_document_base, policy_document)]
  policy_names     = local.managed_policies[*].name

  groups = [for group in local.groups : merge(local.group_base, group)]
  roles  = [for role in local.roles : merge(local.role_base, role)]
  users  = [for user in local.users : merge(local.user_base, user)]

  assume_role_policies = local.assume_role_policies
  inline_policies      = local.inline_policies

  tags = {
    Test = "true"
  }
}

output "create_all" {
  value = module.create_all
}
