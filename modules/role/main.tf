terraform {
  required_version = ">= 0.13"
}

# create the IAM role
resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = var.assume_role_policy

  description           = var.description
  force_detach_policies = var.force_detach_policies
  managed_policy_arns   = var.managed_policy_arns
  max_session_duration  = var.max_session_duration
  path                  = var.path
  permissions_boundary  = var.permissions_boundary

  dynamic "inline_policy" {
    for_each = var.inline_policies
    content {
      name   = inline_policy.value.name
      policy = inline_policy.value.policy
    }
  }

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

# attach an instance profile to the IAM role
resource "aws_iam_instance_profile" "this" {
  count = var.instance_profile ? 1 : 0

  name = aws_iam_role.this.id
  role = aws_iam_role.this.id
}
