locals {
  groups = { for group in var.groups : group.name => group }

  # Construct list of inline policy objects for the policy_documents module
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for group in var.inline_policies : [
      for inline_policy in lookup(group, "inline_policies", []) : {
        id             = "${group.name}:${inline_policy.name}"
        group_name     = group.name
        policy_name    = inline_policy.name
        template       = inline_policy.template
        template_paths = inline_policy.template_paths
        template_vars  = inline_policy.template_vars
      }
    ]
  ])

  # Construct list of inline policy maps for use with for_each
  inline_policy_ids = flatten([
    for group in var.groups : [
      for inline_policy in lookup(group, "inline_policy_names", []) : {
        id          = "${group.name}:${inline_policy}"
        group_name  = group.name
        policy_name = inline_policy
      }
    ]
  ])

  # Construct list of managed policy maps for use with for_each
  managed_policies = flatten([
    for group in var.groups : [
      for policy_arn in lookup(group, "policy_arns", []) : {
        id         = "${group.name}:${policy_arn}"
        group_name = group.name
        policy_arn = policy_arn
      }
    ]
  ])

  # Construct list of group members for use with for_each
  users = flatten([
    for group in var.groups : [
      for user in lookup(group, "user_names", []) : {
        id         = "${user}/${group.name}"
        group_name = group.name
        user       = user
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

# create the IAM groups
resource "aws_iam_group" "this" {
  for_each = local.groups

  name = each.key
  path = each.value.path
}

# attach managed policies to the IAM groups
resource "aws_iam_group_policy_attachment" "this" {
  for_each = { for policy in local.managed_policies : policy.id => policy }

  group      = aws_iam_group.this[each.value.group_name].id
  policy_arn = var.policy_arns[index(var.policy_arns, each.value.policy_arn)]
}

# create inline policies for the IAM groups
resource "aws_iam_group_policy" "this" {
  for_each = { for policy in local.inline_policy_ids : policy.id => policy }

  name   = each.value.policy_name
  group  = aws_iam_group.this[each.value.group_name].id
  policy = module.inline_policy_documents.policies[each.key]
}

# manage group memberships
resource "aws_iam_user_group_membership" "this" {
  for_each = { for user in local.users : user.id => user }

  groups = [aws_iam_group.this[each.value.group_name].id]
  user   = var.user_names[index(var.user_names, each.value.user)]
}
