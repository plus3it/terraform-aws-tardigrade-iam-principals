variable "create_groups" {
  description = "Controls whether IAM groups will be created"
  type        = bool
  default     = true
}

variable "policy_arns" {
  description = "List of all managed policy ARNs used in the groups object. This is needed to properly order policy attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}

variable "groups" {
  description = "Schema list of IAM groups"
  type = list(object({
    name        = string
    path        = string
    policy_arns = list(string)
    user_names  = list(string)
    inline_policies = list(object({
      name           = string
      template       = string
      template_paths = list(string)
      template_vars  = map(string)
    }))
  }))
  default = []
}

variable "user_names" {
  description = "List of all IAM user names used in the groups object. This is needed to properly order group membership attachments/detachments on resource cycles"
  type        = list(string)
  default     = []
}
