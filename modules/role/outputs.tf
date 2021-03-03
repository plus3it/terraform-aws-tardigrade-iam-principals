output "roles" {
  description = "IAM role resource"
  value       = aws_iam_role.this
}

output "instance_profile" {
  description = "IAM instance profile resource"
  value       = aws_iam_instance_profile.this
}
