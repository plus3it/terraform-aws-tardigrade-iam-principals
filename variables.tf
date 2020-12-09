variable "groups" {
  description = "Schema list of IAM groups"
  type = list(object({
    name       = string
    path       = string
    user_names = list(string)
    inline_policies = list(object({
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = any
    }))
    managed_policies = list(object({
      name = string
      arn  = string
    }))
  }))
  default = []
}

variable "policies" {
  description = "Schema list of policy objects"
  type = list(object({
    description    = string
    name           = string
    path           = string
    template       = string
    template_paths = list(string)
    template_vars  = any
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
    assume_role_policy = object({
      template       = string
      template_paths = list(string)
      template_vars  = any
    })
    inline_policies = list(object({
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = any
    }))
    managed_policies = list(object({
      name = string
      arn  = string
    }))
  }))
  default = []
}

variable "users" {
  description = "Schema list of IAM users"
  type = list(object({
    name                 = string
    force_destroy        = bool
    path                 = string
    permissions_boundary = string
    tags                 = map(string)
    inline_policies = list(object({
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = any
    }))
    managed_policies = list(object({
      name = string
      arn  = string
    }))
    access_keys = list(object({
      name    = string
      status  = string
      pgp_key = string
    }))
  }))
  default = []
}
