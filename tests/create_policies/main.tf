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

locals {
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

  policies = [
    {
      name     = "tardigrade-alpha-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template = "policies/template.json"
      template_vars = merge(
        local.template_vars_base,
        {
          account_id = "foo"
        }
      )
    },
    {
      name     = "tardigrade-beta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      path     = "/tardigrade/"
      template = "policies/template.json"
    },
    {
      name        = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template    = "policies/template.json"
    },
    {
      name        = "tardigrade-role-delta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      path        = "/tardigrade/"
      template    = "policies/template.json"
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

output policies {
  value = module.policies
}
