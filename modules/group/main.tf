# create the IAM group
resource "aws_iam_group" "this" {
  name = var.name
  path = var.path
}

# attach managed policies to the IAM groups
resource "aws_iam_group_policy_attachment" "this" {
  for_each = { for policy in var.managed_policies : policy.name => policy }

  group      = aws_iam_group.this.id
  policy_arn = each.value.arn
}

# create inline policies for the IAM groups
resource "aws_iam_group_policy" "this" {
  for_each = { for policy in var.inline_policies : policy.name => policy }

  name   = each.key
  group  = aws_iam_group.this.id
  policy = each.value.policy
}

# manage group memberships
resource "aws_iam_user_group_membership" "this" {
  for_each = { for user_name in var.user_names : user_name => try(
    var.depends_on_users[index(var.depends_on_users, user_name)],
    user_name
  ) }

  groups = [aws_iam_group.this.id]
  user   = each.value
}
