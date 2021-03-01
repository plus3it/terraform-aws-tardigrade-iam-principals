terraform {
  required_version = ">= 0.13"
}

locals {
  depends_on_policies = [for object in module.policies : object.policy.arn]
  depends_on_users    = [for object in module.users : object.user.arn]
}

module "policies" {
  source   = "./modules/policy"
  for_each = { for policy in var.policies : policy.name => policy }

  name   = each.key
  policy = each.value.policy

  description = each.value.description
  path        = each.value.path
}

module "groups" {
  source   = "./modules/group"
  for_each = { for group in var.groups : group.name => group }

  name = each.key

  inline_policies  = each.value.inline_policies
  managed_policies = each.value.managed_policies
  path             = each.value.path
  user_names       = each.value.user_names

  depends_on_policies = local.depends_on_policies
  depends_on_users    = local.depends_on_users
}

module "roles" {
  source   = "./modules/role"
  for_each = { for role in var.roles : role.name => role }

  name               = each.key
  assume_role_policy = each.value.assume_role_policy

  description           = each.value.description
  force_detach_policies = each.value.force_detach_policies
  inline_policies       = each.value.inline_policies
  instance_profile      = each.value.instance_profile
  managed_policy_arns   = each.value.managed_policies[*].arn
  max_session_duration  = each.value.max_session_duration
  path                  = each.value.path
  permissions_boundary  = each.value.permissions_boundary
  tags                  = each.value.tags

  depends_on_policies = local.depends_on_policies
}

module "users" {
  source   = "./modules/user"
  for_each = { for user in var.users : user.name => user }

  name = each.key

  access_keys          = each.value.access_keys
  force_destroy        = each.value.force_destroy
  inline_policies      = each.value.inline_policies
  managed_policies     = each.value.managed_policies
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary
  tags                 = each.value.tags

  depends_on_policies = local.depends_on_policies
}
