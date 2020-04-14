output "groups" {
  description = "IAM group resources"
  value       = aws_iam_group.this
}

output "group_memberships" {
  description = "IAM group membership resources"
  value       = aws_iam_user_group_membership.this
}
