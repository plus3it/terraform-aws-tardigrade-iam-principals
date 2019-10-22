output "role_ids" {
  description = "Returns a map of role names and role ids"
  value       = { for role in aws_iam_role.this : role.name => role.id }
}

output "role_arns" {
  description = "Returns a map of role names and role arns"
  value       = { for role in aws_iam_role.this : role.name => role.arn }
}
