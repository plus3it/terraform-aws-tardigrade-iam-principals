variable "name" {
  description = "Name of the IAM user"
  type        = string
}

variable "access_keys" {
  description = "Schema list of IAM access key attributes, including the access key `name`, `status`, and `pgp_key`"
  type = list(object({
    name    = string
    status  = string
    pgp_key = string
  }))
  default = []
}

variable "depends_on_policies" {
  description = "List of policies created in the same tfstate. Used to manage resource cycles on policy attachments and work around for_each limitations"
  type        = list(string)
  default     = []
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without `force_destroy` a user with non-Terraform-managed access keys and login profile will fail to be destroyed"
  type        = bool
  default     = null
}

variable "inline_policies" {
  description = "Schema list of IAM User inline policies, including `name` and `policy`"
  type = list(object({
    name   = string
    policy = string
  }))
  default = []

  validation {
    condition     = length(var.inline_policies) > 0 ? sum([for item in var.inline_policies : length(jsonencode(jsondecode(item.policy)))]) <= 2048 : true
    error_message = "Combined length of all inline policies exceeds user limit of 2,048 characters."
  }
}

variable "managed_policies" {
  description = "Schema list of IAM managed policies to attach to the user, including the policy `name` and `arn`"
  type = list(object({
    name = string
    arn  = string
  }))
  default = []

  validation {
    condition     = length(var.managed_policies) <= 20
    error_message = "Number of managed policies exceeds role limit of 20."
  }
}

variable "path" {
  description = "Path for the user"
  type        = string
  default     = null
}

variable "permissions_boundary" {
  description = "ARN of the managed policy to set as the permissions boundary for the user"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to apply to all resources that support tags"
  type        = map(string)
  default     = {}
}
