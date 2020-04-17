locals {
  users_map = { for user in var.users : user.name => user }

  # Construct list of inline policy maps for use with for_each
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for user in var.users : [
      for inline_policy in lookup(user, "inline_policies", []) : {
        id            = "${user.name}:${inline_policy.name}"
        user_name     = user.name
        policy_name   = inline_policy.name
        template      = inline_policy.template
        template_vars = inline_policy.template_vars
      }
    ]
  ])

  # Construct list of managed policy maps for use with for_each
  managed_policies = flatten([
    for user in var.users : [
      for policy_arn in lookup(user, "policy_arns", []) : {
        id         = "${user.name}:${policy_arn}"
        user_name  = user.name
        policy_arn = policy_arn
      }
    ]
  ])

  # Construct list of access key maps for use with for_each
  access_keys = flatten([
    for user in var.users : [
      for access_key in lookup(user, "access_keys", []) : {
        id        = "${user.name}:${access_key.name}"
        user_name = user.name
        status    = access_key.status
        pgp_key   = access_key.pgp_key
      }
    ]
  ])
}

module "inline_policy_documents" {
  source = "../policy_documents"

  create_policy_documents = var.create_users

  policies = [for policy_map in local.inline_policies : {
    name          = policy_map.id,
    template      = policy_map.template
    template_vars = policy_map.template_vars
  }]

  template_paths = var.template_paths
  template_vars  = var.template_vars
}

# create the IAM users
resource "aws_iam_user" "this" {
  for_each = var.create_users ? local.users_map : {}

  name = each.key

  force_destroy        = each.value.force_destroy
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary != null ? var.policy_arns[index(var.policy_arns, each.value.permissions_boundary)] : null

  # Merge module-level tags with tags set in the user-schema
  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

# attach managed policies to the IAM users
resource "aws_iam_user_policy_attachment" "this" {
  for_each = var.create_users ? { for policy_map in local.managed_policies : policy_map.id => policy_map } : {}

  policy_arn = var.policy_arns[index(var.policy_arns, each.value.policy_arn)]
  user       = aws_iam_user.this[each.value.user_name].id
}

# create inline policies for the IAM users
resource "aws_iam_user_policy" "this" {
  for_each = var.create_users ? { for policy_map in local.inline_policies : policy_map.id => policy_map } : {}

  name   = each.value.policy_name
  user   = aws_iam_user.this[each.value.user_name].id
  policy = module.inline_policy_documents.policies[each.key]
}

# create access keys for the IAM users
resource "aws_iam_access_key" "this" {
  for_each = var.create_users ? { for access_key in local.access_keys : access_key.id => access_key } : {}

  user    = aws_iam_user.this[each.value.user_name].id
  pgp_key = each.value.pgp_key
  status  = each.value.status
}
