variable "create_roles" {
  description = "Controls whether to create IAM roles"
  type        = bool
  default     = true
}

variable "policy_arns" {
  description = "List of all managed policy ARNs used in the roles object. This is needed to properly order policy attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}

variable "roles" {
  description = "Schema list of IAM roles, consisting of `name`, `assume_role_policy`, `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `description` (OPTIONAL), `force_detach_policies` (OPTIONAL), `instance_profile` (OPTIONAL), `max_session_duration` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL)"
  type = list(object({
    name                  = string
    assume_role_policy    = string
    description           = string
    force_detach_policies = bool
    instance_profile      = bool
    max_session_duration  = number
    path                  = string
    permissions_boundary  = string
    tags                  = map(string)
    policy_arns           = list(string)
    inline_policies = list(object({
      name     = string
      template = string
    }))
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles. Merged with tags set per-role in the role-schema"
  type        = map(string)
  default     = {}
}

variable "template_paths" {
  description = "Paths to the directories containing the IAM policy templates"
  type        = list(string)
}

variable "template_vars" {
  description = "Map of input variables and values for the IAM policy templates."
  type        = map(string)
  default     = {}
}
