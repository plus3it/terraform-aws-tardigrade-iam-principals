# create the IAM role
resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = var.assume_role_policy

  description           = var.description
  force_detach_policies = var.force_detach_policies
  managed_policy_arns   = concat([for name, policy in data.aws_iam_policy.this : policy.arn], var.managed_policy_arns)
  max_session_duration  = var.max_session_duration
  path                  = var.path
  permissions_boundary  = var.permissions_boundary

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )

  lifecycle {
    precondition {
      condition     = length(var.managed_policies) + length(var.managed_policy_arns) <= 20
      error_message = "The combination of `managed_policy_arns` and `managed_policies` exceeds role limit of 20 total policies."
    }
  }
}

resource "aws_iam_role_policy" "this" {
  for_each = { for policy in var.inline_policies : policy.name => policy }

  name   = each.value.name
  policy = each.value.policy
  role   = aws_iam_role.this.name
}

resource "aws_iam_role_policies_exclusive" "this" {
  role_name    = aws_iam_role.this.name
  policy_names = [for name, policy in aws_iam_role_policy.this : policy.name]
}

# attach an instance profile to the IAM role
resource "aws_iam_instance_profile" "this" {
  count = var.instance_profile != null ? 1 : 0

  name = var.instance_profile.name
  path = var.instance_profile.path
  role = aws_iam_role.this.id
}

data "aws_iam_policy" "this" {
  for_each = { for policy in var.managed_policies : policy.name => policy }

  arn = each.value.arn
}
