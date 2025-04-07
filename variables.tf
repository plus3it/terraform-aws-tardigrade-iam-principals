variable "groups" {
  description = "Schema list of IAM groups"
  type = list(object({
    name       = string
    path       = optional(string)
    user_names = optional(list(string), [])
    inline_policies = optional(list(object({
      name   = string
      policy = string
    })), [])
    managed_policies = optional(list(object({
      name = string
      arn  = optional(string)
    })), [])
  }))
  default = []
}

variable "policies" {
  description = "Schema list of policy objects"
  type = list(object({
    name        = string
    policy      = string
    description = optional(string)
    path        = optional(string)
    tags        = optional(map(string))
  }))
  default = []
}

variable "policy_documents" {
  description = "Schema list of IAM policy documents"
  type        = any
  # Using `any` because template_vars may have differing element types, which generates
  # an error when terraform converts the values to a list. However, the real type is:
  # type = list(object({
  #   name           = string
  #   template       = string
  #   template_paths = list(string)
  #   template_vars  = any
  # }))
  default = []
}

variable "roles" {
  description = "Schema list of IAM roles"
  type = list(object({
    name                  = string
    assume_role_policy    = string
    description           = optional(string)
    force_detach_policies = optional(bool)
    instance_profile = optional(object({
      name = string
      path = optional(string)
    }))
    max_session_duration = optional(number)
    path                 = optional(string)
    permissions_boundary = optional(string)
    tags                 = optional(map(string))
    inline_policies = optional(list(object({
      name   = string
      policy = string
    })), [])
    managed_policies = optional(list(object({
      name = string
      arn  = optional(string)
    })), [])
  }))
  default = []
}

variable "users" {
  description = "Schema list of IAM users"
  type = list(object({
    name                 = string
    force_destroy        = optional(bool)
    path                 = optional(string)
    permissions_boundary = optional(string)
    tags                 = optional(map(string))
    inline_policies = optional(list(object({
      name   = string
      policy = string
    })), [])
    managed_policies = optional(list(object({
      name = string
      arn  = optional(string)
    })), [])
    access_keys = optional(list(object({
      name    = string
      status  = optional(string)
      pgp_key = optional(string)
    })), [])
  }))
  default = []
}
