terraform {
  required_version = ">= 0.12"
}

module "policies" {
  source = "./modules/policies/"

  create_policies = var.create_policies
  template_paths  = var.template_paths
  template_vars   = var.template_vars

  policies = var.policies
}

module "roles" {
  source = "./modules/roles/"

  policy_arns = distinct(concat(
    var.policy_arns,
    [for policy in module.policies.policies : policy.arn]
  ))

  create_roles   = var.create_roles
  template_paths = var.template_paths
  template_vars  = var.template_vars

  description           = var.description
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  path                  = var.path
  permissions_boundary  = var.permissions_boundary
  tags                  = var.tags

  roles = var.roles
}

module "users" {
  source = "./modules/users/"

  policy_arns = distinct(concat(
    var.policy_arns,
    [for policy in module.policies.policies : policy.arn]
  ))

  create_users   = var.create_users
  template_paths = var.template_paths
  template_vars  = var.template_vars

  force_destroy        = var.force_destroy
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  tags                 = var.tags

  users = var.users
}
