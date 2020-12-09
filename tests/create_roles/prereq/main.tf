provider aws {
  region = "us-east-1"
}

module policies {
  source   = "../../..//modules/policy"
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
      "${path.module}/../../templates/"
    ]
  }

  template_vars_base = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  policies = [
    {
      name     = "tardigrade-alpha-create-roles-test"
      template = "policies/template.json.hcl.tpl"
    },
    {
      name     = "tardigrade-beta-create-roles-test"
      path     = "/tardigrade/"
      template = "policies/template.json.hcl.tpl"
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

output policies {
  value = module.policies
}

output random_string {
  value = random_string.this
}
