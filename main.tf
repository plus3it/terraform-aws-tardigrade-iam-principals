locals {
  depends_on_policies = [for object in module.policies : object.policy.arn]
  depends_on_users    = [for object in module.users : object.user.arn]
}

module "policy_documents" {
  source   = "./modules/policy_document"
  for_each = { for document in var.policy_documents : document.name => document }

  template       = try(each.value.template, null)
  templates      = try(each.value.templates, [])
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

module "policies" {
  source   = "./modules/policy"
  for_each = { for policy in var.policies : policy.name => policy }

  name = each.key

  # First, try to get the policy from the policy documents module
  # Second, just use the policy attribute directly
  policy = try(
    module.policy_documents[each.value.policy].policy_document,
    each.value.policy,
  )

  description = each.value.description
  path        = each.value.path
  tags        = each.value.tags
}

module "groups" {
  source   = "./modules/group"
  for_each = { for group in var.groups : group.name => group }

  name = each.key

  managed_policies = each.value.managed_policies
  path             = each.value.path
  user_names       = each.value.user_names

  inline_policies = [for policy in each.value.inline_policies : {
    name = policy.name
    # First, try to get the inline policy from the policy documents module
    # Second, just use the policy attribute directly
    policy = try(
      module.policy_documents[policy.policy].policy_document,
      policy.policy
    )
  }]

  depends_on_policies = local.depends_on_policies
  depends_on_users    = local.depends_on_users
}

module "roles" {
  source   = "./modules/role"
  for_each = { for role in var.roles : role.name => role }

  name = each.key

  # First, try to get the assume role policy from the policy documents module
  # Second, just use the assume role policy attribute directly
  assume_role_policy = try(
    module.policy_documents[each.value.assume_role_policy].policy_document,
    each.value.assume_role_policy
  )

  description           = each.value.description
  force_detach_policies = each.value.force_detach_policies
  instance_profile      = each.value.instance_profile
  managed_policy_arns   = each.value.managed_policies[*].arn
  max_session_duration  = each.value.max_session_duration
  path                  = each.value.path
  permissions_boundary  = each.value.permissions_boundary
  tags                  = each.value.tags

  inline_policies = [for policy in each.value.inline_policies : {
    name = policy.name
    # First, try to get the inline policy from the policy documents module
    # Second, just use the policy attribute directly
    policy = try(
      module.policy_documents[policy.policy].policy_document,
      policy.policy
    )
  }]

  depends_on_policies = local.depends_on_policies
}

module "users" {
  source   = "./modules/user"
  for_each = { for user in var.users : user.name => user }

  name = each.key

  access_keys          = each.value.access_keys
  force_destroy        = each.value.force_destroy
  managed_policies     = each.value.managed_policies
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary
  tags                 = each.value.tags

  inline_policies = [for policy in each.value.inline_policies : {
    name = policy.name
    # First, try to get the inline policy from the policy documents module
    # Second, just use the policy attribute directly
    policy = try(
      module.policy_documents[policy.policy].policy_document,
      policy.policy
    )
  }]

  depends_on_policies = local.depends_on_policies
}
