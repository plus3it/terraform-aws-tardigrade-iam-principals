variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "Assume role policy document for the IAM role"
  type        = string

  validation {
    condition     = length(var.assume_role_policy) <= 4096
    error_message = "Length of assume role policy exceeds limit of 4,096 characters."
  }
}

variable "depends_on_policies" {
  description = "List of policies created in the same tfstate. Used to manage resource cycles on policy attachments and work around for_each limitations"
  type        = list(string)
  default     = []
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Boolean to control whether to force detach any policies the role has before destroying it"
  type        = bool
  default     = null
}

variable "inline_policies" {
  description = "Schema list of IAM Role inline policies, including `name` and `policy`"
  type = list(object({
    name   = string
    policy = string
  }))
  default = []

  validation {
    condition     = length(var.inline_policies) > 0 ? sum([for item in var.inline_policies : length(item.policy)]) <= 10240 : true
    error_message = "Combined length of all inline policies exceeds role limit of 10,240 characters."
  }
}

variable "instance_profile" {
  description = "Schema object of a role's instance profile"
  type = object({
    name = string
    path = string
  })
  default = null
}

variable "managed_policy_arns" {
  description = "List of IAM managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.managed_policy_arns) <= 20
    error_message = "Number of managed policies exceeds role limit of 20."
  }
}

variable "max_session_duration" {
  description = "Maximum session duration (in seconds) to set for the role. The default is one hour. This setting can have a value from 1 hour to 12 hours"
  type        = number
  default     = null
}

variable "path" {
  description = "Path for the role"
  type        = string
  default     = null
}

variable "permissions_boundary" {
  description = "ARN of the managed policy to set as the permissions boundary for the role"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to apply to all resources that support tags"
  type        = map(string)
  default     = {}
}
