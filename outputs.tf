output groups {
  description = "IAM group resources"
  value       = module.groups
}

output policies {
  description = "IAM managed policy resources"
  value       = module.policies
}

output roles {
  description = "IAM role resources"
  value       = module.roles
}

output users {
  description = "IAM user resources"
  value       = module.users
}
