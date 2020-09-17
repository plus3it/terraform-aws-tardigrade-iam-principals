locals {
  users = { for user in var.users : user.name => user }

  # Construct list of inline policy objects for the policy_documents module
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for user in var.inline_policies : [
      for inline_policy in lookup(user, "inline_policies", []) : {
        id             = "${user.name}:${inline_policy.name}"
        user_name      = user.name
        policy_name    = inline_policy.name
        template       = inline_policy.template
        template_paths = inline_policy.template_paths
        template_vars  = inline_policy.template_vars
      }
    ]
  ])

  # Construct list of inline policy maps for use with for_each
  inline_policy_ids = flatten([
    for user in var.users : [
      for inline_policy in lookup(user, "inline_policy_names", []) : {
        id          = "${user.name}:${inline_policy}"
        user_name   = user.name
        policy_name = inline_policy
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

  policy_names = local.inline_policy_ids[*].id

  policies = [
    for policy in local.inline_policies : {
      name           = policy.id,
      template       = policy.template
      template_paths = policy.template_paths
      template_vars  = policy.template_vars
    }
  ]
}

# create the IAM users
resource "aws_iam_user" "this" {
  for_each = local.users

  name = each.key

  force_destroy        = each.value.force_destroy
  path                 = each.value.path
  permissions_boundary = each.value.permissions_boundary != null ? var.policy_arns[index(var.policy_arns, each.value.permissions_boundary)] : null

  # Merge module-level tags with tags set in the user-schema
  tags = merge(var.tags, lookup(each.value, "tags", {}))
}

# attach managed policies to the IAM users
resource "aws_iam_user_policy_attachment" "this" {
  for_each = { for policy in local.managed_policies : policy.id => policy }

  policy_arn = var.policy_arns[index(var.policy_arns, each.value.policy_arn)]
  user       = aws_iam_user.this[each.value.user_name].id
}

# create inline policies for the IAM users
resource "aws_iam_user_policy" "this" {
  for_each = { for policy in local.inline_policy_ids : policy.id => policy }

  name   = each.value.policy_name
  user   = aws_iam_user.this[each.value.user_name].id
  policy = module.inline_policy_documents.policies[each.key]
}

# create access keys for the IAM users
resource "aws_iam_access_key" "this" {
  for_each = { for access_key in local.access_keys : access_key.id => access_key }

  user    = aws_iam_user.this[each.value.user_name].id
  pgp_key = each.value.pgp_key
  status  = each.value.status
}
