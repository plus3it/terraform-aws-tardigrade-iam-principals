locals {
  handler_vars = {
    template_paths = join(",", var.template_paths)
  }

  users_map = { for item in var.users : item.name => item }
}

data "external" "handler" {
  for_each = var.create_users ? local.users_map : {}

  program = ["python", "${path.module}/../iam_handler.py", "-"]
  query   = merge(local.handler_vars, each.value)
}

################################
#
# Process policy templates
#
################################

# variable assignment within the policies
data "template_file" "policies" {
  for_each = { for name, user in local.users_map : name => user if var.create_users && var.create_policies && lookup(user, "policy", null) != null }

  template = base64decode(data.external.handler[each.key].result["policy"])
  vars     = var.template_vars
}

# variable assignment within the inline policies
data "template_file" "inline_policies" {
  for_each = { for name, user in local.users_map : name => user if var.create_users && var.create_policies && lookup(user, "inline_policy", null) != null }

  template = base64decode(data.external.handler[each.key].result["inline_policy"])
  vars     = var.template_vars
}

################################
#
# IAM user creation
#
################################

resource "aws_iam_user" "this" {
  for_each = var.create_users ? local.users_map : {}

  name = data.external.handler[each.key].result["name"]
  path = lookup(data.external.handler[each.key].result, "path", null)
  tags = var.tags
}

################################
#
# Create and attach the policies
#
################################

# create the role policy
resource "aws_iam_policy" "this" {
  for_each = { for name, user in local.users_map : name => user if var.create_users && var.create_policies && lookup(user, "policy", null) != null }

  name   = data.external.handler[each.key].result["name"]
  policy = data.template_file.policies[each.key].rendered
}

# attach created IAM policies to the IAM user
resource "aws_iam_user_policy_attachment" "created" {
  for_each = { for name, user in local.users_map : name => user if var.create_users && var.create_policies && lookup(user, "policy", null) != null }

  policy_arn = aws_iam_policy.this[each.key].arn
  user       = aws_iam_user.this[each.key].id
}

# attach pre-existing IAM policy ARNs to the IAM role
resource "aws_iam_user_policy_attachment" "preexisting" {
  for_each = { for name, user in local.users_map : name => user if var.create_users && ! var.create_policies && lookup(user, "policy", null) != null }

  policy_arn = var.users[each.key]["policy"]
  user       = aws_iam_user.this[each.key].id
}

# create inline policy for IAM role where inline policy presents
resource "aws_iam_user_policy" "this" {
  for_each = { for name, user in local.users_map : name => user if var.create_users && var.create_policies && lookup(user, "inline_policy", null) != null }

  name   = data.external.handler[each.key].result["name"]
  user   = aws_iam_user.this[each.key].id
  policy = data.template_file.inline_policies[each.key].rendered
}
