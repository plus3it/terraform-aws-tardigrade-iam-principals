variable "create_policy_documents" {
  description = "Controls whether to process IAM policy documents"
  type        = bool
  default     = true
}

variable "policies" {
  description = "Schema list of policy objects, consisting of `name`, and `template` policy filename (relative to `template_paths`)"
  type = list(object({
    name     = string
    template = string
  }))
  default = []
}

variable "template_paths" {
  description = "Paths to the directories containing the IAM policy templates"
  type        = list(string)
}

variable "template_vars" {
  description = "Map of template input variables for IAM policy templates"
  type        = map(string)
  default     = {}
}
