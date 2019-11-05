variable "create_users" {
  description = "Controls whether an IAM user will be created"
  type        = bool
  default     = true
}

variable "dependencies" {
  description = "List of dependency resources applied to `depends_on` in every resource in this module. Typically used with IAM managed policy ARNs that are managed in the same Terraform config"
  type        = list(string)
  default     = []
}

variable "force_destroy" {
  description = "When destroying these users, destroy even if they have non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed. May also be set per-user in the user-schema"
  type        = bool
  default     = true
}

variable "path" {
  description = "The path to the user. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html) for more information. May also be set per-user in the user-schema"
  type        = string
  default     = null
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the users. May also be set per-user in the user-schema"
  type        = string
  default     = null
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

variable "tags" {
  description = "Map of tags to apply to the IAM roles"
  type        = map(string)
  default     = {}
}

variable "users" {
  description = "Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL)"
  type        = list
  default     = []
}
