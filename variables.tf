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
    name        = string
    path        = string
    policy_arns = list(string)
    user_names  = list(string)
    inline_policies = list(object({
      name     = string
      template = string
    }))
  }))
  default = []
}

variable "policy_arns" {
  description = "List of all managed policy ARNs used in the roles, groups, and users objects. This is needed to properly order policy attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "Schema list of policy objects"
  type = list(object({
    name        = string
    template    = string
    description = string
    path        = string
  }))
  default = []
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
      name     = string
      template = string
    }))
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles and users. May also be set per-role/user in the role/user-schemas"
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

variable "users" {
  description = "Schema list of IAM users"
  type = list(object({
    name                 = string
    force_destroy        = bool
    path                 = string
    permissions_boundary = string
    tags                 = map(string)
    policy_arns          = list(string)
    inline_policies = list(object({
      name     = string
      template = string
    }))
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
