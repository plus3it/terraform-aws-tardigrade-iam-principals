# create the IAM users
resource "aws_iam_user" "this" {
  name                 = var.name
  force_destroy        = var.force_destroy
  path                 = var.path
  permissions_boundary = var.permissions_boundary

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )

  depends_on = [
    var.depends_on_policies
  ]
}

# attach managed policies to the IAM users
resource "aws_iam_user_policy_attachment" "this" {
  for_each = data.aws_iam_policy.this

  policy_arn = each.value.arn
  user       = aws_iam_user.this.id

  depends_on = [
    var.depends_on_policies
  ]
}

# create inline policies for the IAM users
resource "aws_iam_user_policy" "this" {
  for_each = { for policy in var.inline_policies : policy.name => policy }

  name   = each.key
  user   = aws_iam_user.this.id
  policy = each.value.policy
}

# create access keys for the IAM users
resource "aws_iam_access_key" "this" {
  for_each = { for access_key in var.access_keys : access_key.name => access_key }

  user    = aws_iam_user.this.id
  pgp_key = each.value.pgp_key
  status  = each.value.status
}

data "aws_iam_policy" "this" {
  for_each = { for policy in var.managed_policies : policy.name => policy }

  arn = each.value.arn

  depends_on = [
    var.depends_on_policies
  ]
}
