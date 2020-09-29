terraform {
  required_version = ">= 0.13"
}

locals {
  inline_policies  = { for policy in var.inline_policies : policy.name => policy }
  managed_policies = { for policy in var.managed_policies : policy.name => policy }
}

# template the inline policy documents
module inline_policy_documents {
  source   = "../policy_document"
  for_each = local.inline_policies

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

# create the IAM group
resource aws_iam_group this {
  name = var.name
  path = var.path
}

# attach managed policies to the IAM groups
resource aws_iam_group_policy_attachment this {
  for_each = local.managed_policies

  group      = aws_iam_group.this.id
  policy_arn = each.value.arn

  depends_on = [
    var.depends_on_policies
  ]
}

# create inline policies for the IAM groups
resource aws_iam_group_policy this {
  for_each = local.inline_policies

  name   = each.key
  group  = aws_iam_group.this.id
  policy = module.inline_policy_documents[each.key].policy_document
}

# manage group memberships
resource aws_iam_user_group_membership this {
  for_each = toset(var.user_names)

  groups = [aws_iam_group.this.id]
  user   = each.key

  depends_on = [
    var.depends_on_users
  ]
}
