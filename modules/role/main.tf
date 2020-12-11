terraform {
  required_version = ">= 0.13"
}

# create the IAM role
resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = var.assume_role_policy

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
resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for policy in var.managed_policies : policy.name => policy }

  policy_arn = each.value.arn
  role       = aws_iam_role.this.id

  depends_on = [
    var.depends_on_policies
  ]
}

# create inline policies for the IAM roles
resource "aws_iam_role_policy" "this" {
  for_each = { for policy in var.inline_policies : policy.name => policy }

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value.policy
}

# attach an instance profile to the IAM role
resource "aws_iam_instance_profile" "this" {
  count = var.instance_profile ? 1 : 0

  name = aws_iam_role.this.id
  role = aws_iam_role.this.id
}
