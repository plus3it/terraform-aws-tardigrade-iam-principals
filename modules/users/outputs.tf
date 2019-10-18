output "user_unique_ids" {
  description = "Returns a map of user names and user unique ids"
  value       = { for user in aws_iam_user.this : user.name => user.unique_id }
}

output "user_arns" {
  description = "Returns a map of user names and user arns"
  value       = { for user in aws_iam_user.this : user.name => user.arn }
}
