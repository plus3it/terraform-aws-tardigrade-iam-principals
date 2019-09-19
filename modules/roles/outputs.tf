output "role_ids" {
  description = "Returns a map of role names and role ids"
  value       = zipmap(aws_iam_role.this.*.name, aws_iam_role.this.*.id)
}

output "role_arns" {
  description = "Returns a map of role names and role arns"
  value       = zipmap(aws_iam_role.this.*.name, aws_iam_role.this.*.arn)
}

