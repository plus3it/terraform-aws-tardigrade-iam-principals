module "create_users" {
  source   = "../../modules/user"
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

module "policy_documents" {
  source   = "../../modules/policy_document"
  for_each = { for policy_document in local.policy_documents : policy_document.name => merge(local.policy_document_base, policy_document) }

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

locals {
  users = [
    {
      name                 = "tardigrade-user-alpha-${local.test_id}"
      inline_policies      = local.inline_policies
      managed_policies     = local.managed_policies
      access_keys          = local.access_keys
      force_destroy        = false
      path                 = "/tardigrade/alpha/"
      permissions_boundary = data.terraform_remote_state.prereq.outputs.policies["tardigrade-beta-create-users-test"].policy.arn
      tags = {
        Env = "tardigrade"
      }
    },
    {
      name                 = "tardigrade-user-beta-${local.test_id}"
      managed_policies     = local.managed_policies
      inline_policies      = local.inline_policies
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
      policy = module.policy_documents["tardigrade-beta-${local.test_id}"].policy_document
    },
  ]

  managed_policies = [for object in data.terraform_remote_state.prereq.outputs.policies : {
    name = object.policy.name
    arn  = object.policy.arn
  }]

  access_keys = [for access_key in [
    {
      name = "tardigrade-alpha-${local.test_id}"
    },
    {
      name = "tardigrade-beta-${local.test_id}"
    },
  ] : merge(local.access_key_base, access_key)]

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

  access_key_base = {
    pgp_key = null
    status  = null
  }

  user_base = {
    access_keys          = []
    force_destroy        = null
    inline_policies      = []
    managed_policies     = []
    path                 = null
    permissions_boundary = data.terraform_remote_state.prereq.outputs.policies["tardigrade-alpha-create-users-test"].policy.arn
    tags                 = {}
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

output "create_users" {
  value     = module.create_users
  sensitive = true
}
