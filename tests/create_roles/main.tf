provider aws {
  region = "us-east-1"
}

module create_roles {
  source   = "../..//modules/role"
  for_each = { for role in local.roles : role.name => merge(local.role_base, role) }

  name               = each.key
  assume_role_policy = each.value.assume_role_policy

  description           = each.value.description
  force_detach_policies = each.value.force_detach_policies
  inline_policies       = each.value.inline_policies
  instance_profile      = each.value.instance_profile
  managed_policies      = each.value.managed_policies
  max_session_duration  = each.value.max_session_duration
  path                  = each.value.path
  permissions_boundary  = each.value.permissions_boundary
  tags                  = each.value.tags
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

  role_base = {
    assume_role_policy    = local.assume_role_policy
    description           = null
    force_detach_policies = null
    inline_policies       = []
    instance_profile      = null
    managed_policies      = []
    max_session_duration  = null
    path                  = null
    permissions_boundary  = data.terraform_remote_state.prereq.outputs.policies["tardigrade-alpha-create-roles-test"].policy.arn
    tags                  = {}
  }

  assume_role_policy = {
    template       = "trusts/template.json.hcl.tpl"
    template_paths = ["${path.module}/../templates/"]
    template_vars  = local.template_vars_base
  }

  roles = [
    {
      name                  = "tardigrade-role-alpha-${local.test_id}"
      inline_policies       = local.inline_policies
      managed_policies      = local.managed_policies
      description           = "Managed by Terraform - Tardigrade test policy"
      force_detach_policies = false
      max_session_duration  = 3600
      path                  = "/tardigrade/alpha/"
      permissions_boundary  = data.terraform_remote_state.prereq.outputs.policies["tardigrade-beta-create-roles-test"].policy.arn
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name                 = "tardigrade-role-beta-${local.test_id}"
      inline_policies      = local.inline_policies
      managed_policies     = local.managed_policies
      permissions_boundary = null
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

output create_roles {
  value = module.create_roles
}
