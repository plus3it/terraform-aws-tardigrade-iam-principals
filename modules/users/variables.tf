variable "create_users" {
  description = "Controls whether an IAM user will be created"
  type        = bool
  default     = true
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

variable "policy_arns" {
  description = "List of all managed policy ARNs used in the users object. This is needed to properly order policy attachments/detachments on resource cycles"
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

variable "tags" {
  description = "Map of tags to apply to the IAM roles"
  type        = map(string)
  default     = {}
}

variable "users" {
  description = "Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `access_keys` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL)"
  type = list(object({
    name                 = string
    force_destroy        = bool
    path                 = string
    permissions_boundary = string
    tags                 = map(string)
    policy_arns          = list(string)
    inline_policies = list(object({
      name     = string
      template = string
    }))
    access_keys = list(object({
      name    = string
      status  = string
      pgp_key = string
    }))
  }))
  default = []
}
