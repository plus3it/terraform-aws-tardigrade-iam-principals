terraform {
  required_version = ">= 0.13"
}

locals {
  access_keys      = { for access_key in var.access_keys : access_key.name => access_key }
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

# create the IAM users
resource aws_iam_user this {
  name                 = var.name
  force_destroy        = var.force_destroy
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  tags                 = var.tags
}

# attach managed policies to the IAM users
resource aws_iam_user_policy_attachment this {
  for_each = local.managed_policies

  policy_arn = each.value.arn
  user       = aws_iam_user.this.id
}

# create inline policies for the IAM users
resource aws_iam_user_policy this {
  for_each = local.inline_policies

  name   = each.key
  user   = aws_iam_user.this.id
  policy = module.inline_policy_documents[each.key].policy_document
}

# create access keys for the IAM users
resource aws_iam_access_key this {
  for_each = local.access_keys

  user    = aws_iam_user.this.id
  pgp_key = each.value.pgp_key
  status  = each.value.status
}
