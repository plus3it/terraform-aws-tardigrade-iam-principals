variable name {
  description = "Name of the IAM group"
  type        = string
}

variable inline_policies {
  description = "Schema list of IAM User inline policies, see `policy_document` for attribute descriptions"
  type = list(object({
    name           = string
    template       = string
    template_paths = list(string)
    template_vars  = map(string)
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
