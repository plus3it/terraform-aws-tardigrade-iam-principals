terraform {
  required_version = ">= 0.13"
}

locals {
  inline_policies  = { for policy in var.inline_policies : policy.name => policy }
  managed_policies = { for policy in var.managed_policies : policy.name => policy }
}

# template the assume role policy document
module assume_role_policy_document {
  source = "../policy_document"

  template       = var.assume_role_policy.template
  template_paths = var.assume_role_policy.template_paths
  template_vars  = var.assume_role_policy.template_vars
}

# template the inline policy documents
module inline_policy_documents {
  source   = "../policy_document"
  for_each = local.inline_policies

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

# create the IAM roles
resource aws_iam_role this {
  name               = var.name
  assume_role_policy = module.assume_role_policy_document.policy_document

  description           = var.description
  force_detach_policies = var.force_detach_policies
  max_session_duration  = var.max_session_duration
  path                  = var.path
  permissions_boundary  = var.permissions_boundary
  tags                  = var.tags

  depends_on = [
    var.depends_on_policies
  ]
}

# attach managed policies to the IAM roles
resource aws_iam_role_policy_attachment this {
  for_each = local.managed_policies

  policy_arn = each.value.arn
  role       = aws_iam_role.this.id

  depends_on = [
    var.depends_on_policies
  ]
}

# create inline policies for the IAM roles
resource aws_iam_role_policy this {
  for_each = local.inline_policies

  name   = each.key
  role   = aws_iam_role.this.id
  policy = module.inline_policy_documents[each.key].policy_document
}

# attach an instance profile to the IAM roles
resource aws_iam_instance_profile this {
  for_each = toset(var.instance_profile == true ? [var.name] : [])

  name = aws_iam_role.this.id
  role = aws_iam_role.this.id
}
