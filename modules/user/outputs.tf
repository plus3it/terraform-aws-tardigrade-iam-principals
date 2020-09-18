output user {
  description = "IAM user resource"
  value       = aws_iam_user.this
}

output access_keys {
  description = "IAM access key resources"
  value       = aws_iam_access_key.this
  sensitive   = true
}

output managed_policies {
  description = "IAM managed policy attachment resources"
  value       = aws_iam_user_policy_attachment.this
}

output inline_policies {
  description = "IAM inline policy attachment resources"
  value       = aws_iam_user_policy.this
}
