locals {
  handler_vars = {
    template_paths = join(",", var.template_paths)
  }
}

data "external" "handler" {
  count = var.create_users ? length(var.users) : 0

  program = ["python", "${path.module}/../iam_handler.py", "-"]
  query   = merge(local.handler_vars, var.users[count.index])
}

################################
#
# Process policy templates
#
################################

# variable assignment within the policies
data "template_file" "policies" {
  count = var.create_users ? length(var.users) : 0

  template = base64decode(data.external.handler[count.index].result["policy"])
  vars     = var.template_vars
}

# define the IAM policy document
data "aws_iam_policy_document" "policies" {
  count = var.create_users && var.create_policies ? length(var.users) : 0

  source_json = data.template_file.policies[count.index].rendered
}

# variable assignment within the inline policies
data "template_file" "inline_policies" {
  count = var.create_users && var.create_policies ? length(var.users) : 0

  template = base64decode(data.external.handler[count.index].result["inline_policy"])
  vars     = var.template_vars
}

################################
#
# IAM user creation
#
################################

resource "aws_iam_user" "this" {
  count = var.create_users ? length(var.users) : 0

  name = data.external.handler[count.index].result["name"]
  path = data.external.handler[count.index].result["path"]

  # permissions_boundary = "${lookup(data.external.handler.*.result[count.index], "permission_boundary")}"
  tags = var.tags
}

################################
#
# Create and attach the policies
#
################################

# create the role policy
resource "aws_iam_policy" "this" {
  count = var.create_users && var.create_policies ? length(var.users) : 0

  name   = data.external.handler[count.index].result["name"]
  policy = data.aws_iam_policy_document.policies[count.index].json
}

# attach created IAM policies to the IAM user
resource "aws_iam_user_policy_attachment" "created" {
  count = var.create_users && var.create_policies ? length(var.users) : 0

  policy_arn = aws_iam_policy.this[count.index].arn
  user       = aws_iam_user.this[count.index].id
}

# attach pre-existing IAM policy ARNs to the IAM role
resource "aws_iam_user_policy_attachment" "preexisting" {
  count = var.create_users && !var.create_policies ? length(var.users) : 0

  policy_arn = var.users[count.index]["policy"]
  user       = aws_iam_user.this[count.index].id
}

# create inline policy for IAM role where inline policy presents
resource "aws_iam_user_policy" "this" {
  count = var.create_users && var.create_policies ? length(var.users) : 0

  name   = data.external.handler[count.index].result["name"]
  user   = aws_iam_user.this[count.index].id
  policy = data.template_file.inline_policies[count.index].rendered
}

