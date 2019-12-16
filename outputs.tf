output "policies" {
  description = "IAM managed policy resources"
  value       = length(module.policies) > 0 ? module.policies.policies : null
}

output "roles" {
  description = "IAM role resources"
  value       = length(module.roles) > 0 ? module.roles.roles : null
}

output "users" {
  description = "IAM user resources"
  value       = length(module.users) > 0 ? module.users.users : null
}

output "access_keys" {
  description = "IAM access key resources"
  value       = length(module.users) > 0 ? module.users.access_keys : null
  sensitive   = true
}
