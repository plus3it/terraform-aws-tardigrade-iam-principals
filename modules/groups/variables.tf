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

variable "template_paths" {
  description = "Paths to the directories containing the templates for IAM policies and trusts"
  type        = list(string)
}

variable "template_vars" {
  description = "Map of input variables for IAM trust and policy templates"
  type        = map(string)
  default     = {}
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
