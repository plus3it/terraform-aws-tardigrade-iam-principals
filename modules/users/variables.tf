variable "template_paths" {
  description = "Paths to the directories containing the templates for IAM policies and trusts"
  type        = "list"
}

variable "create_users" {
  description = "Controls whether an IAM user will be created"
  default     = true
}

variable "users" {
  description = "Schema list of users, consisting of user name, policy path, and permission boundary, policy name, and policy path"
  type        = "list"
  default     = []
}

variable "create_policies" {
  description = "Controls whether to create IAM policies"
  default     = true
}

variable "template_vars" {
  description = "Map of input variables for IAM trust and policy templates"
  type        = "map"
  default     = {}
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles"
  type        = "map"
  default     = {}
}
