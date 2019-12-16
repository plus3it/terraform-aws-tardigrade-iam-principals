output "users" {
  description = "IAM user resources"
  value       = aws_iam_user.this
}

output "access_keys" {
  description = "IAM access key resources"
  value       = aws_iam_access_key.this
  sensitive   = true
}
