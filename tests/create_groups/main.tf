provider aws {
  region = "us-east-1"
}

module create_groups {
  source   = "../../modules/group"
  for_each = { for group in local.groups : group.name => merge(local.group_base, group) }

  name             = each.key
  inline_policies  = each.value.inline_policies
  managed_policies = each.value.managed_policies
  path             = each.value.path
  user_names       = each.value.user_names
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

  managed_policies = [for object in data.terraform_remote_state.prereq.outputs.policies : {
    name = object.policy.name
    arn  = object.policy.arn
  }]

  group_base = {
    inline_policies  = []
    managed_policies = []
    path             = null
    user_names       = []
  }

  groups = [
    {
      name             = "tardigrade-group-alpha-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
      path             = "/tardigrade/alpha/"
    },
    {
      name             = "tardigrade-group-beta-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
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

output create_groups {
  value = module.create_groups
}
