variable "template_paths" {
  description = "Paths to the directories containing the templates for IAM policies and trusts"
  type        = list(string)
}

variable "create_users" {
  description = "Controls whether an IAM user will be created"
  type        = bool
  default     = true
}

variable "users" {
  description = "Schema list of users, consisting of `name`, `policy_path`, and `permission_boundary`, `policy_name`, and `inline_policy`"
  type        = list
  default     = []
}

variable "create_policies" {
  description = "Controls whether to create IAM policies"
  type        = bool
  default     = true
}

variable "template_vars" {
  description = "Map of input variables for IAM trust and policy templates"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles"
  type        = map(string)
  default     = {}
}

