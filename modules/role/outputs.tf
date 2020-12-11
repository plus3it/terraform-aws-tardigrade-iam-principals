output "roles" {
  description = "IAM role resource"
  value       = aws_iam_role.this
}

output "managed_policies" {
  description = "IAM managed policy attachment resources"
  value       = aws_iam_role_policy_attachment.this
}

output "inline_policies" {
  description = "IAM inline policy attachment resources"
  value       = aws_iam_role_policy.this
}

output "instance_profile" {
  description = "IAM instance profile resource"
  value       = aws_iam_instance_profile.this
}
