variable name {
  description = "Name of the IAM role"
  type        = string
}

variable assume_role_policy {
  description = "Schema map of attributes for the assume role policy, see `policy_document` for attribute descriptions"
  type = object({
    template       = string
    template_paths = list(string)
    template_vars  = map(string)
  })
}

variable description {
  description = "Description of the IAM role"
  type        = string
  default     = null
}

variable force_detach_policies {
  description = "Boolean to control whether to force detach any policies the role has before destroying it"
  type        = bool
  default     = null
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

variable instance_profile {
  description = "Boolean to control whether to create an instance profile for the role"
  type        = bool
  default     = false
}

variable managed_policies {
  description = "Schema list of IAM managed policies to attach to the user, including the policy `name` and `arn`"
  type = list(object({
    name = string
    arn  = string
  }))
  default = []
}

variable max_session_duration {
  description = "Maximum session duration (in seconds) to set for the role. The default is one hour. This setting can have a value from 1 hour to 12 hours"
  type        = number
  default     = null
}

variable path {
  description = "Path for the role"
  type        = string
  default     = null
}

variable permissions_boundary {
  description = "ARN of the managed policy to set as the permissions boundary for the user"
  type        = string
  default     = null
}

variable tags {
  description = "Map of tags to apply to all resources that support tags"
  type        = map(string)
  default     = {}
}
