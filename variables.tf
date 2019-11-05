variable "create_policies" {
  description = "Controls whether to create IAM policies"
  type        = bool
  default     = true
}

variable "create_roles" {
  description = "Controls whether to create IAM roles"
  type        = bool
  default     = true
}

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

variable "description" {
  description = "Description of the roles. May also be set per-role in the role-schema"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "When destroying these users, destroy even if they have non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed. May also be set per-user in the user-schema"
  type        = bool
  default     = true
}

variable "force_detach_policies" {
  description = "Force detaches any policies the roles have before destroying them. May also be set per-role in the role-schema"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours. May also be set per-role in the role-schema"
  type        = number
  default     = null
}

variable "path" {
  description = "The path to the role. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html) for more information. May also be set per-role in the role-schema"
  type        = string
  default     = null
}

variable "permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the roles. May also be set per-role in the role-schema"
  type        = string
  default     = null
}

variable "policies" {
  description = "Schema list of policy objects, consisting of `name`, `template` policy filename (relative to `template_paths`), (OPTIONAL) `description`, (OPTIONAL) `path`"
  type        = list(map(string))
  default     = []
}

variable "roles" {
  description = "Schema list of IAM roles, consisting of `name`, `assume_role_policy`, `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `description` (OPTIONAL), `force_detach_polices` (OPTIONAL), `max_session_duration` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL)"
  type        = list
  default     = []
}

variable "tags" {
  description = "Map of tags to apply to the IAM roles. May also be set per-role in the role-schema"
  type        = map(string)
  default     = {}
}

variable "template_paths" {
  description = "Paths to the directories containing the IAM policy templates"
  type        = list(string)
}

variable "template_vars" {
  description = "Map of input variables and values for the IAM policy templates."
  type        = map(string)
  default     = {}
}

variable "users" {
  description = "Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL)"
  type        = list
  default     = []
}
