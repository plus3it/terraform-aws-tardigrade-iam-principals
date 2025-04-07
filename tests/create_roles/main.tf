module "create_roles" {
  source   = "../../modules/role"
  for_each = { for role in local.roles : role.name => merge(local.role_base, role) }

  name               = each.key
  assume_role_policy = each.value.assume_role_policy

  description           = each.value.description
  force_detach_policies = each.value.force_detach_policies
  inline_policies       = each.value.inline_policies
  instance_profile      = each.value.instance_profile
  managed_policy_arns   = each.value.managed_policy_arns
  max_session_duration  = each.value.max_session_duration
  path                  = each.value.path
  permissions_boundary  = each.value.permissions_boundary
  tags                  = each.value.tags
}

module "policy_documents" {
  source   = "../../modules/policy_document"
  for_each = { for policy_document in local.policy_documents : policy_document.name => merge(local.policy_document_base, policy_document) }

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

locals {
  roles = [
    {
      name                  = "tardigrade-role-alpha-${local.test_id}"
      inline_policies       = local.inline_policies
      managed_policy_arns   = local.managed_policy_arns
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
      managed_policy_arns  = local.managed_policy_arns
      permissions_boundary = null
    },
    {
      name                = "tardigrade-role-chi-${local.test_id}"
      managed_policy_arns = local.managed_policy_arns
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
  ]

  policy_documents = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
    {
      name     = "tardigrade-assume-role-${local.test_id}"
      template = "trusts/template.json"
    },
  ]

  inline_policies = [
    {
      name   = "tardigrade-alpha-${local.test_id}"
      policy = module.policy_documents["tardigrade-alpha-${local.test_id}"].policy_document
    },
    {
      name   = "tardigrade-beta-${local.test_id}"
      policy = module.policy_documents["tardigrade-alpha-${local.test_id}"].policy_document
    },
  ]

  managed_policy_arns = [for object in data.terraform_remote_state.prereq.outputs.policies : object.policy.arn]

  policy_document_base = {
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

  role_base = {
    assume_role_policy    = module.policy_documents["tardigrade-assume-role-${local.test_id}"].policy_document
    description           = null
    force_detach_policies = null
    inline_policies       = []
    instance_profile      = null
    managed_policy_arns   = []
    max_session_duration  = null
    path                  = null
    permissions_boundary  = data.terraform_remote_state.prereq.outputs.policies["tardigrade-alpha-create-roles-test"].policy.arn
    tags                  = {}
  }
}

locals {
  test_id = data.terraform_remote_state.prereq.outputs.random_string.result
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  numeric = false
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

output "create_roles" {
  value = module.create_roles
}
