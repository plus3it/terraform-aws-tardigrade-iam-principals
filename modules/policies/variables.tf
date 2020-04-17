variable "create_policies" {
  description = "Controls whether to create IAM policies"
  type        = bool
  default     = true
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

variable "template_paths" {
  description = "Paths to the directories containing the IAM policy templates"
  type        = list(string)
  default     = []
}

variable "template_vars" {
  description = "Map of template input variables for IAM policy templates"
  type        = map(string)
  default     = {}
}
