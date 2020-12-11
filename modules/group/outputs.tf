output "group" {
  description = "IAM group resource"
  value       = aws_iam_group.this
}

output "group_memberships" {
  description = "IAM group membership resources"
  value       = aws_iam_user_group_membership.this
}

output "managed_policies" {
  description = "IAM managed policy attachment resources"
  value       = aws_iam_group_policy_attachment.this
}

output "inline_policies" {
  description = "IAM inline policy attachment resources"
  value       = aws_iam_group_policy.this
}
