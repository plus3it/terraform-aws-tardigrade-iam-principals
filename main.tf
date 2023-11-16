locals {
  depends_on_users = [for object in module.users : object.user.arn]
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

  path       = each.value.path
  user_names = each.value.user_names

  inline_policies = [for policy in each.value.inline_policies : {
    name = policy.name
    # First, try to get the inline policy from the policy documents module
    # Second, just use the policy attribute directly
    policy = try(
      module.policy_documents[policy.policy].policy_document,
      policy.policy
    )
  }]

  managed_policies = [for policy in each.value.managed_policies : {
    name = policy.name
    # First, try to get the managed policy arn from the policies module
    # Second, just use the arn attribute directly
    arn = try(
      module.policies[policy.name].policy.arn,
      policy.arn
    )
  }]

  depends_on_users = local.depends_on_users
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
  max_session_duration  = each.value.max_session_duration
  path                  = each.value.path
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

  managed_policies = [for policy in each.value.managed_policies : {
    name = policy.name
    # First, try to get the managed policy arn from the policies module
    # Second, just use the arn attribute directly
    arn = try(
      module.policies[policy.name].policy.arn,
      policy.arn
    )
  }]

  # First, try to get the permissions boundary arn from the policies module
  # Second, just use the permissions boundary attribute directly
  permissions_boundary = try(
    module.policies[each.value.permissions_boundary].policy.arn,
    each.value.permissions_boundary
  )
}

module "users" {
  source   = "./modules/user"
  for_each = { for user in var.users : user.name => user }

  name = each.key

  access_keys   = each.value.access_keys
  force_destroy = each.value.force_destroy
  path          = each.value.path
  tags          = each.value.tags

  inline_policies = [for policy in each.value.inline_policies : {
    name = policy.name
    # First, try to get the inline policy from the policy documents module
    # Second, just use the policy attribute directly
    policy = try(
      module.policy_documents[policy.policy].policy_document,
      policy.policy
    )
  }]

  managed_policies = [for policy in each.value.managed_policies : {
    name = policy.name
    # First, try to get the managed policy arn from the policies module
    # Second, just use the arn attribute directly
    arn = try(
      module.policies[policy.name].policy.arn,
      policy.arn
    )
  }]

  # First, try to get the permissions boundary arn from the policies module
  # Second, just use the permissions boundary attribute directly
  permissions_boundary = try(
    module.policies[each.value.permissions_boundary].policy.arn,
    each.value.permissions_boundary
  )
}
