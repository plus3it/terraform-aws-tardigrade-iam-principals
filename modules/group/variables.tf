variable name {
  description = "Name of the IAM group"
  type        = string
}

variable depends_on_policies {
  description = "List of policies created in the same tfstate. Used to manage resource cycles on policy attachments and work around for_each limitations"
  type        = list(string)
  default     = []
}

variable depends_on_users {
  description = "List of users created in the same tfstate. Used to manage resource cycles on user membership and work around for_each limitations"
  type        = list(string)
  default     = []
}

variable inline_policies {
  description = "Schema list of IAM User inline policies, see `policy_document` for attribute descriptions"
  type = list(object({
    name           = string
    template       = string
    template_paths = list(string)
    template_vars  = any
  }))
  default = []
}

variable managed_policies {
  description = "Schema list of IAM managed policies to attach to the user, including the policy `name` and `arn`"
  type = list(object({
    name = string
    arn  = string
  }))
  default = []
}

variable path {
  description = "Path for the group"
  type        = string
  default     = null
}

variable user_names {
  description = "List of all IAM usernames to manage as members of the group"
  type        = list(string)
  default     = []
}
