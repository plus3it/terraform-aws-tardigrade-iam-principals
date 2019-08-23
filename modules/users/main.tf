locals {
  handler_vars = {
    template_paths = "${join(",", var.template_paths)}"
  }
}

data "external" "handler" {
  count = "${var.create_users ? length(var.users) : 0}"

  program = ["python", "${path.module}/../iam_handler.py", "-"]
  query   = "${merge(local.handler_vars, var.users[count.index])}"
}

################################
#
# Process policy templates
#
################################

# variable assignment within the policies
data "template_file" "policies" {
  count = "${var.create_users ? length(var.users) : 0}"

  template = "${base64decode(lookup(data.external.handler.*.result[count.index], "policy"))}"
  vars     = "${var.template_vars}"
}

# define the IAM policy document
data "aws_iam_policy_document" "policies" {
  count = "${var.create_users && var.create_policies ? length(var.users) : 0 }"

  source_json = "${data.template_file.policies.*.rendered[count.index]}"
}

# variable assignment within the inline policies
data "template_file" "inline_policies" {
  count = "${var.create_users && var.create_policies ? length(var.users) : 0}"

  template = "${base64decode(lookup(data.external.handler.*.result[count.index], "inline_policy"))}"
  vars     = "${var.template_vars}"
}

################################
#
# IAM user creation
#
################################

resource "aws_iam_user" "this" {
  count = "${var.create_users ? length(var.users) : 0}"

  name = "${lookup(data.external.handler.*.result[count.index], "name")}"
  path = "${lookup(data.external.handler.*.result[count.index], "path")}"

  # permissions_boundary = "${lookup(data.external.handler.*.result[count.index], "permission_boundary")}"
  tags = "${var.tags}"
}

################################
#
# Create and attach the policies
#
################################

# create the role policy
resource "aws_iam_policy" "this" {
  count = "${var.create_users && var.create_policies ? length(var.users) : 0}"

  name   = "${lookup(data.external.handler.*.result[count.index], "name")}"
  policy = "${data.aws_iam_policy_document.policies.*.json[count.index]}"
}

# attach created IAM policies to the IAM user
resource "aws_iam_user_policy_attachment" "created" {
  count = "${var.create_users && var.create_policies ? length(var.users) : 0}"

  policy_arn = "${aws_iam_policy.this.*.arn[count.index]}"
  user       = "${aws_iam_user.this.*.id[count.index]}"
}

# attach pre-existing IAM policy ARNs to the IAM role
resource "aws_iam_user_policy_attachment" "preexisting" {
  count = "${var.create_users && !var.create_policies ? length(var.users) : 0}"

  policy_arn = "${lookup(var.users[count.index], "policy")}"
  user       = "${aws_iam_user.this.*.id[count.index]}"
}

# create inline policy for IAM role where inline policy presents
resource "aws_iam_user_policy" "this" {
  count = "${var.create_users && var.create_policies ? length(var.users) : 0}"

  name   = "${lookup(data.external.handler.*.result[count.index], "name")}"
  user   = "${aws_iam_user.this.*.id[count.index]}"
  policy = "${data.template_file.inline_policies.*.rendered[count.index]}"
}
