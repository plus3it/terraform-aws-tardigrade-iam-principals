variable "create_policies" {
  description = "Controls whether to create IAM policies"
  type        = bool
  default     = true
}

variable "policies" {
  description = "Schema list of policy objects"
  type = list(object({
    description    = string
    name           = string
    path           = string
    template       = string
    template_paths = list(string)
    template_vars  = map(string)
  }))
  default = []
}
