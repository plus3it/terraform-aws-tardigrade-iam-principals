locals {
  handler_vars = {
    template_paths = join(",", var.template_paths)
  }
}

data "external" "handler" {
  count = var.create_roles ? length(var.roles) : 0

  program = ["python", "${path.module}/../iam_handler.py", "-"]
  query   = merge(local.handler_vars, var.roles[count.index])
}

################################
#
# Process policy templates
#
################################

# variable assignment within the policies
data "template_file" "policies" {
  count = var.create_roles && var.create_policies ? length(var.roles) : 0

  template = base64decode(data.external.handler[count.index].result["policy"])
  vars     = var.template_vars
}

# variable assignment within the inline policies
data "template_file" "inline_policies" {
  count = var.create_roles && var.create_policies ? length(var.roles) : 0

  template = base64decode(data.external.handler[count.index].result["inline_policy"])
  vars     = var.template_vars
}

################################
#
# Process trust templates
#
################################

# variable assignment within base trusts
data "template_file" "trusts" {
  count = var.create_roles ? length(var.roles) : 0

  template = base64decode(data.external.handler[count.index].result["trust"])
  vars     = var.template_vars
}

################################
#
# IAM role creation
#
################################

# create the IAM role
resource "aws_iam_role" "this" {
  count = var.create_roles ? length(var.roles) : 0

  name                  = data.external.handler[count.index].result["name"]
  assume_role_policy    = data.template_file.trusts[count.index].rendered
  force_detach_policies = true
  max_session_duration  = var.max_session_duration
  tags                  = var.tags
}

# create the role policy
resource "aws_iam_policy" "this" {
  count = var.create_roles && var.create_policies ? length(var.roles) : 0

  name   = data.external.handler[count.index].result["name"]
  policy = data.template_file.policies[count.index].rendered
}

# attach created IAM policies to the IAM role
resource "aws_iam_role_policy_attachment" "created" {
  count = var.create_roles && var.create_policies ? length(var.roles) : 0

  policy_arn = aws_iam_policy.this[count.index].arn
  role       = aws_iam_role.this[count.index].id
}

# attach pre-existing IAM policy ARNs to the IAM role
resource "aws_iam_role_policy_attachment" "preexisting" {
  count = var.create_roles && !var.create_policies ? length(var.roles) : 0

  policy_arn = var.roles[count.index]["policy"]
  role       = aws_iam_role.this[count.index].id
}

# create inline policy for IAM role where inline policy presents
resource "aws_iam_role_policy" "this" {
  count = var.create_roles && var.create_policies ? length(var.roles) : 0

  name   = data.external.handler[count.index].result["name"]
  role   = aws_iam_role.this[count.index].id
  policy = data.template_file.inline_policies[count.index].rendered
}

################################
#
# Instance profile creation
#
################################

# attach the IAM policy to the Instance Role
resource "aws_iam_instance_profile" "this" {
  count = var.create_roles && var.create_instance_profiles ? length(var.roles) : 0

  name = data.external.handler[count.index].result["name"]
  role = aws_iam_role.this[count.index].id
}
