variable "assume_role_policies" {
  description = "Schema list of assume role policy objects for the IAM Roles"
  type = list(object({
    name           = string
    template       = string
    template_paths = list(string)
    template_vars  = map(string)
  }))
  default = []
}

variable "create_roles" {
  description = "Controls whether to create IAM roles"
  type        = bool
  default     = true
}

variable "inline_policies" {
  description = "Schema list of IAM Role inline policies"
  type = list(object({
    name = string
    inline_policies = list(object({
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = map(string)
    }))
  }))
  default = []
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
    description           = string
    force_detach_policies = bool
    inline_policy_names   = list(string)
    instance_profile      = bool
    max_session_duration  = number
    path                  = string
    permissions_boundary  = string
    policy_arns           = list(string)
    tags                  = map(string)
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles. Merged with tags set per-role in the role-schema"
  type        = map(string)
  default     = {}
}
