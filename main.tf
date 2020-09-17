terraform {
  required_version = ">= 0.12"
}

locals {
  policy_arns = distinct(concat(
    var.policy_arns,
    [for policy in module.policies.policies : policy.arn]
  ))

  user_names = distinct(concat(
    var.user_names,
    [for user in module.users.users : user.name]
  ))

  group_inline_policies = [
    for policy in var.inline_policies : {
      name            = policy.name
      inline_policies = policy.inline_policies
    } if policy.type == "group"
  ]

  role_inline_policies = [
    for policy in var.inline_policies : {
      name            = policy.name
      inline_policies = policy.inline_policies
    } if policy.type == "role"
  ]

  user_inline_policies = [
    for policy in var.inline_policies : {
      name            = policy.name
      inline_policies = policy.inline_policies
    } if policy.type == "user"
  ]
}

module "policies" {
  source = "./modules/policies/"

  policies         = var.policies
  policy_documents = var.policy_documents
  policy_names     = var.policy_names
}

module "groups" {
  source = "./modules/groups/"

  policy_arns = local.policy_arns
  user_names  = local.user_names

  groups          = var.groups
  inline_policies = local.group_inline_policies
}

module "roles" {
  source = "./modules/roles/"

  policy_arns = local.policy_arns

  assume_role_policies = var.assume_role_policies
  inline_policies      = local.role_inline_policies
  roles                = var.roles
  tags                 = var.tags
}

module "users" {
  source = "./modules/users/"

  policy_arns = local.policy_arns

  inline_policies = local.user_inline_policies
  tags            = var.tags
  users           = var.users
}
