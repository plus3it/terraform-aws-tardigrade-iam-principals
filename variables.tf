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

variable "description" {
  description = "Description of the roles. May also be set per-role in the role-schema"
  type        = string
  default     = null
}

variable "policy_arns" {
  description = "List of all managed policy ARNs used in the roles and users objects. This is needed to properly order policy attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "Schema list of policy objects, consisting of `name`, `template` policy filename (relative to `template_paths`), (OPTIONAL) `description`, (OPTIONAL) `path`"
  type = list(object({
    name        = string
    template    = string
    description = string
    path        = string
  }))
  default = []
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
  description = "Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `access_keys` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL)"
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
