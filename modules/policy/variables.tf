variable "name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "policy" {
  description = "Policy document for the IAM policy"
  type        = string
}

variable "description" {
  description = "Description for the IAM policy"
  type        = string
  default     = null
}

variable "path" {
  description = "Path for the IAM policy"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to apply to all resources that support tags"
  type        = map(string)
  default     = {}
}
