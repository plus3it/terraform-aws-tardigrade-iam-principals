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
  description = "Schema list of IAM roles"
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
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = map(string)
    }))
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles. Merged with tags set per-role in the role-schema"
  type        = map(string)
  default     = {}
}
