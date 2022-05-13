module "create_all" {
  source = "../../"

  policies = local.policies

  groups = local.groups
  roles  = local.roles
  users  = local.users
}

module "policy_documents" {
  source   = "../../modules/policy_document"
  for_each = { for policy_document in local.policy_documents : policy_document.name => merge(local.policy_document_base, policy_document) }

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

/*
  To detect resource cycles on IAM policies when adding resources to policy
  documents:

  1. apply the prereqs
  2. apply the test config
  3. uncomment the commented lines
  4. re-apply the test config

  The failure is when ALL policies are cycled, instead of just the one policy
  that is changing.
*/

/*
resource "random_string" "foo" {
  length  = 6
  upper   = false
  special = false
  number  = false
}
*/

locals {
  groups = [for group in [
    {
      name             = "tardigrade-group-alpha-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
      path             = "/tardigrade/alpha/"
      user_names       = local.users[*].name
    },
    {
      name             = "tardigrade-group-beta-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
      user_names       = ["tardigrade-user-beta-${local.test_id}"]
    },
    {
      name             = "tardigrade-group-chi-${local.test_id}"
      managed_policies = local.managed_policies
    },
    {
      name            = "tardigrade-group-delta-${local.test_id}"
      inline_policies = local.inline_policies
    },
    {
      name = "tardigrade-group-epsilon-${local.test_id}"
    },
  ] : merge(local.group_base, group)]

  roles = [for role in [
    {
      name                  = "tardigrade-role-alpha-${local.test_id}"
      inline_policies       = local.inline_policies
      managed_policies      = local.managed_policies
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
      name             = "tardigrade-role-beta-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
    },
    {
      name             = "tardigrade-role-chi-${local.test_id}"
      managed_policies = local.managed_policies
    },
    {
      name            = "tardigrade-role-delta-${local.test_id}"
      inline_policies = local.inline_policies
    },
    {
      name = "tardigrade-role-epsilon-${local.test_id}"
    },
    {
      name = "tardigrade-role-phi-${local.test_id}"
      instance_profile = {
        name = "tardigrade-role-phi-${local.test_id}"
        path = null
      }
    },
  ] : merge(local.role_base, role)]

  users = [for user in [
    {
      name                 = "tardigrade-user-alpha-${local.test_id}"
      inline_policies      = local.inline_policies
      managed_policies     = local.managed_policies
      access_keys          = local.access_keys
      force_destroy        = false
      path                 = "/tardigrade/alpha/"
      permissions_boundary = "${local.policy_arn_base}/tardigrade/tardigrade-beta-${local.test_id}"
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name             = "tardigrade-user-beta-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
    },
    {
      name             = "tardigrade-user-chi-${local.test_id}"
      managed_policies = local.managed_policies
    },
    {
      name            = "tardigrade-user-delta-${local.test_id}"
      inline_policies = local.inline_policies
    },
    {
      name = "tardigrade-user-epsilon-${local.test_id}"
    },
  ] : merge(local.user_base, user)]

  policies = [for policy in [
    {
      name   = "tardigrade-alpha-${local.test_id}"
      policy = module.policy_documents["tardigrade-alpha-${local.test_id}"].policy_document
    },
    {
      name   = "tardigrade-beta-${local.test_id}"
      path   = "/tardigrade/"
      policy = module.policy_documents["tardigrade-beta-${local.test_id}"].policy_document
    },
  ] : merge(local.policy_base, policy)]

  policy_documents = [
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
              "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${local.random_string}",
              # Do not remove! Used to detect resource cycles, see comments above.
              # "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${local.random_string}",
            ]
          )
        }
      )
    },
    {
      name     = "tardigrade-alpha-inline-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-inline-${local.test_id}"
      template = "policies/complex_object.json.hcl.tpl"
      template_vars = merge(
        local.template_vars_base,
        {
          allowed_regions = [
            "us-east-1",
            "us-east-2"
          ]
          instance_arns = [
            "arn:${local.partition}:ec2:${local.region}:${local.account_id}:instance/*",
            "arn:${local.partition}:ec2:${local.region}:${local.account_id}:instance/i-${local.random_string}"
          ]
        }
      )
    },
    {
      name     = "tardigrade-assume-role-${local.test_id}"
      template = "trusts/template.json"
    },
  ]

  inline_policies = [
    {
      name   = "tardigrade-alpha-${local.test_id}"
      policy = module.policy_documents["tardigrade-alpha-inline-${local.test_id}"].policy_document
    },
    {
      name   = "tardigrade-beta-${local.test_id}"
      policy = module.policy_documents["tardigrade-beta-inline-${local.test_id}"].policy_document
    },
  ]

  managed_policies = [
    {
      name = "tardigrade-alpha-${local.test_id}"
      arn  = "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}"
    },
    {
      name = "tardigrade-beta-${local.test_id}"
      arn  = "${local.policy_arn_base}/tardigrade/tardigrade-beta-${local.test_id}"
    },
  ]

  access_keys = [for access_key in [
    {
      name = "tardigrade-alpha-${local.test_id}"
    },
    {
      name = "tardigrade-beta-${local.test_id}"
    },
  ] : merge(local.access_key_base, access_key)]

  policy_arn_base = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy"

  policy_base = {
    path        = null
    description = null
  }

  policy_document_base = {
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/",
      "${path.module}/../resource_cycle/",
    ]
  }

  template_vars_base = {
    account_id    = local.account_id
    partition     = local.partition
    region        = local.region
    random_string = local.random_string
    instance_arns = join(
      "\",\"",
      [
        "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
      ]
    )
  }

  access_key_base = {
    pgp_key = null
    status  = null
  }

  group_base = {
    inline_policies  = []
    managed_policies = []
    path             = null
    user_names       = []
  }

  role_base = {
    assume_role_policy    = module.policy_documents["tardigrade-assume-role-${local.test_id}"].policy_document
    description           = null
    force_detach_policies = null
    inline_policies       = []
    instance_profile      = null
    managed_policies      = []
    max_session_duration  = null
    path                  = null
    permissions_boundary  = "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}"
    tags                  = {}
  }

  user_base = {
    access_keys          = []
    inline_policies      = []
    managed_policies     = []
    force_destroy        = null
    path                 = null
    permissions_boundary = "${local.policy_arn_base}/tardigrade-alpha-${local.test_id}"
    tags                 = {}
  }
}

locals {
  test_id = data.terraform_remote_state.prereq.outputs.random_string.result

  account_id    = data.aws_caller_identity.current.account_id
  partition     = data.aws_partition.current.partition
  region        = data.aws_region.current.name
  random_string = random_string.this.result
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
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

output "create_all" {
  value     = module.create_all
  sensitive = true
}
