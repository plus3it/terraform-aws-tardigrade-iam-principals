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

variable "create_groups" {
  description = "Controls whether to create IAM groups"
  type        = bool
  default     = true
}

variable "create_policies" {
  description = "Controls whether to create IAM policies"
  type        = bool
  default     = true
}

variable "create_roles" {
  description = "Controls whether to create IAM roles"
  type        = bool
  default     = true
}

variable "create_users" {
  description = "Controls whether an IAM user will be created"
  type        = bool
  default     = true
}

variable "groups" {
  description = "Schema list of IAM groups"
  type = list(object({
    name                = string
    path                = string
    policy_arns         = list(string)
    user_names          = list(string)
    inline_policy_names = list(string)
  }))
  default = []
}

variable "inline_policies" {
  description = "Schema list of inline policies for groups, users, and roles"
  type = list(object({
    name = string
    type = string
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
  description = "List of all managed policy ARNs used in the roles, groups, and users objects. This is needed to properly order policy attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}

variable "policy_names" {
  description = "List of policy names in the `policies` objects"
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "Schema list of policy objects"
  type = list(object({
    description    = string
    name           = string
    path           = string
  }))
  default = []
}

variable "policy_documents" {
  description = "Schema list of policy_document objects"
  type = list(object({
    name           = string
    template       = string
    template_paths = list(string)
    template_vars  = map(string)
  }))
  default = []
}

variable "roles" {
  description = "Schema list of IAM roles"
  type = list(object({
    name                  = string
    description           = string
    force_detach_policies = bool
    instance_profile      = bool
    max_session_duration  = number
    path                  = string
    permissions_boundary  = string
    tags                  = map(string)
    policy_arns           = list(string)
    inline_policy_names   = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles and users. May also be set per-role/user in the role/user-schemas"
  type        = map(string)
  default     = {}
}

variable "users" {
  description = "Schema list of IAM users"
  type = list(object({
    name                 = string
    force_destroy        = bool
    path                 = string
    permissions_boundary = string
    tags                 = map(string)
    policy_arns          = list(string)
    inline_policy_names  = list(string)
    access_keys = list(object({
      name    = string
      status  = string
      pgp_key = string
    }))
  }))
  default = []
}

variable "user_names" {
  description = "List of all IAM user names used in the groups object. This is needed to properly order group membership attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}
