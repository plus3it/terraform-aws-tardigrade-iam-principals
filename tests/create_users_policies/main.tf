provider aws {
  region = "us-east-1"
}

module policies {
  source   = "../..//modules/policy"
  for_each = { for policy in local.policies : policy.name => merge(local.policy_base, policy) }

  description    = each.value.description
  name           = each.key
  path           = each.value.path
  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

module create_users {
  source   = "../..//modules/user"
  for_each = { for user in local.users : user.name => merge(local.user_base, user) }

  name                 = each.key
  access_keys          = each.value.access_keys
  force_destroy        = each.value.force_destroy
  inline_policies      = each.value.inline_policies
  managed_policies     = each.value.managed_policies
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary
  tags                 = each.value.tags
}

locals {
  test_id = data.terraform_remote_state.prereq.outputs.random_string.result

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

  user_base = {
    access_keys          = []
    inline_policies      = []
    managed_policies     = []
    force_destroy        = null
    path                 = null
    permissions_boundary = module.policies["tardigrade-alpha-${local.test_id}"].policy.arn
    tags                 = {}
  }

  inline_policies = [for policy in [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
    },
  ] : merge(local.policy_base, policy)]

  managed_policies = [for name, object in module.policies : {
    name = name
    arn  = object.policy.arn
  }]

  policies = [
    {
      description = "test"
      name        = "tardigrade-alpha-${local.test_id}"
      template    = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      path     = "/tardigrade/"
      template = "policies/template.json"
    },
  ]

  users = [
    {
      name                 = "tardigrade-user-alpha-${local.test_id}"
      inline_policies      = local.inline_policies
      managed_policies     = local.managed_policies
      force_destroy        = false
      path                 = "/tardigrade/alpha/"
      permissions_boundary = module.policies["tardigrade-beta-${local.test_id}"].policy.arn
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name                 = "tardigrade-user-beta-${local.test_id}"
      inline_policies      = local.inline_policies
      managed_policies     = local.managed_policies
      permissions_boundary = null
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
  ]
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

output create_users {
  value = module.create_users
}
