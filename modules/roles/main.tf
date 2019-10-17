locals {
  handler_vars = {
    template_paths = join(",", var.template_paths)
  }

  roles_map = { for item in var.roles : item.name => item }
}

data "external" "handler" {
  for_each = var.create_roles ? local.roles_map : {}

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
  for_each = var.create_roles && var.create_policies ? local.roles_map : {}

  template = base64decode(data.external.handler[each.key].result["policy"])
  vars     = var.template_vars
}

# variable assignment within the inline policies
data "template_file" "inline_policies" {
  for_each = var.create_roles && var.create_policies ? local.roles_map : {}

  template = base64decode(data.external.handler[each.key].result["inline_policy"])
  vars     = var.template_vars
}

################################
#
# Process trust templates
#
################################

# variable assignment within base trusts
data "template_file" "trusts" {
  for_each = var.create_roles ? local.roles_map : {}

  template = base64decode(data.external.handler[each.key].result["trust"])
  vars     = var.template_vars
}

################################
#
# IAM role creation
#
################################

# create the IAM role
resource "aws_iam_role" "this" {
  for_each = var.create_roles ? local.roles_map : {}

  name                  = data.external.handler[each.key].result["name"]
  assume_role_policy    = data.template_file.trusts[each.key].rendered
  force_detach_policies = true
  max_session_duration  = var.max_session_duration
  tags                  = var.tags
}

# create the role policy
resource "aws_iam_policy" "this" {
  for_each = var.create_roles && var.create_policies ? local.roles_map : {}

  name   = data.external.handler[each.key].result["name"]
  policy = data.template_file.policies[each.key].rendered
}

# attach created IAM policies to the IAM role
resource "aws_iam_role_policy_attachment" "created" {
  for_each = var.create_roles && var.create_policies ? local.roles_map : {}

  policy_arn = aws_iam_policy.this[each.key].arn
  role       = aws_iam_role.this[each.key].id
}

# attach pre-existing IAM policy ARNs to the IAM role
resource "aws_iam_role_policy_attachment" "preexisting" {
  for_each = var.create_roles && !var.create_policies ? local.roles_map : {}

  policy_arn = var.roles[each.key]["policy"]
  role       = aws_iam_role.this[each.key].id
}

# create inline policy for IAM role where inline policy presents
resource "aws_iam_role_policy" "this" {
  for_each = var.create_roles && var.create_policies ? local.roles_map : {}

  name   = data.external.handler[each.key].result["name"]
  role   = aws_iam_role.this[each.key].id
  policy = data.template_file.inline_policies[each.key].rendered
}

################################
#
# Instance profile creation
#
################################

# attach the IAM policy to the Instance Role
resource "aws_iam_instance_profile" "this" {
  for_each = var.create_roles && var.create_instance_profiles ? local.roles_map : {}

  name = data.external.handler[each.key].result["name"]
  role = aws_iam_role.this[each.key].id
}
