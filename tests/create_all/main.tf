provider aws {
  region = "us-east-1"
}

module create_all {
  source = "../../"

  policies = local.policies

  groups = local.groups
  users  = local.users

  roles = [for role in local.roles : merge(
    role,
    {
      inline_policies = [
        // This setup is designed to test for_each issues with inline policies. The "lookup" approach
        // below causes a for_each error:
        //for policy in lookup(role, "inline_policies", []) : merge(
        // but if the role object is *guaranteed* to have the inline_policies attribute then the
        // the lookup is not needed and this will work:
        for policy in role.inline_policies : merge(
          policy,
          {
            template_vars = merge(
              local.template_vars_base,
              {
                instance_arns = join(
                  "\",\"",
                  [
                    "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${random_string.this.result}",
                  ]
                )
              }
            )
          }
        )
      ]
    }
  )]
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
  test_id = data.terraform_remote_state.prereq.outputs.random_string.result

  policy_arn_base = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy"

  policy_base = {
    path          = null
    description   = null
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/",
      "${path.module}/../resource_cycle/",
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

  access_key_base = {
    pgp_key = null
    status  = null
  }

  access_keys = [for access_key in [
    {
      name = "tardigrade-alpha-${local.test_id}"
    },
    {
      name = "tardigrade-beta-${local.test_id}"
    },
  ] : merge(local.access_key_base, access_key)]

  inline_policies = [for policy in [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
  ] : merge(local.policy_base, policy)]

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

  policies = [for policy in [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      path     = "/tardigrade/"
      template = "policies/template.json.hcl.tpl"
      template_vars = merge(
        local.template_vars_base,
        {
          instance_arns = join(
            "\",\"",
            [
              "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
              "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${random_string.this.result}",
              // Do not remove! Used to detect resource cycles, see comments above.
              //"arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${random_string.foo.result}",
            ]
          )
        }
      )
    },
  ] : merge(local.policy_base, policy)]

  group_base = {
    inline_policies  = []
    managed_policies = []
    path             = null
    user_names       = []
  }

  role_base = {
    assume_role_policy    = local.assume_role_policy
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

  assume_role_policy = {
    template       = "trusts/template.json.hcl.tpl"
    template_paths = ["${path.module}/../templates/"]
    template_vars  = local.template_vars_base
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
      name             = "tardigrade-role-phi-${local.test_id}"
      instance_profile = true
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
}

resource random_string this {
  length  = 6
  upper   = false
  special = false
  number  = false
}

data aws_caller_identity current {}

data aws_partition current {}

data aws_region current {}

data terraform_remote_state prereq {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

output create_all {
  value = module.create_all
}
