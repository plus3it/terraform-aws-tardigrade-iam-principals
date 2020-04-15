locals {
  groups_map = { for group in var.groups : group.name => group }

  # Construct list of inline policy maps for use with for_each
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for group in var.groups : [
      for inline_policy in lookup(group, "inline_policies", []) : {
        id          = "${group.name}:${inline_policy.name}"
        group_name  = group.name
        policy_name = inline_policy.name
        template    = inline_policy.template
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

  create_policy_documents = var.create_groups

  policies       = [for policy_map in local.inline_policies : { name = policy_map.id, template = policy_map.template }]
  template_paths = var.template_paths
  template_vars  = var.template_vars
}

# create the IAM groups
resource "aws_iam_group" "this" {
  for_each = var.create_groups ? local.groups_map : {}

  name = each.key
  path = each.value.path
}

# attach managed policies to the IAM groups
resource "aws_iam_group_policy_attachment" "this" {
  for_each = var.create_groups ? { for policy_map in local.managed_policies : policy_map.id => policy_map } : {}

  group      = aws_iam_group.this[each.value.group_name].id
  policy_arn = var.policy_arns[index(var.policy_arns, each.value.policy_arn)]
}

# create inline policies for the IAM groups
resource "aws_iam_group_policy" "this" {
  for_each = var.create_groups ? { for policy_map in local.inline_policies : policy_map.id => policy_map } : {}

  name   = each.value.policy_name
  group  = aws_iam_group.this[each.value.group_name].id
  policy = module.inline_policy_documents.policies[each.key]
}

# manage group memberships
resource "aws_iam_user_group_membership" "this" {
  for_each = var.create_groups ? { for user in local.users : user.id => user } : {}

  groups = [aws_iam_group.this[each.value.group_name].id]
  user   = var.user_names[index(var.user_names, each.value.user)]
}
