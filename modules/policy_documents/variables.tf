variable "create_policy_documents" {
  description = "Controls whether to process IAM policy documents"
  type        = bool
  default     = true
}

variable "policy_names" {
  description = "List of policy names in the `policies` objects"
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "Schema list of policy objects"
  type = list(object({
    name           = string
    template       = string
    template_paths = list(string)
    template_vars  = map(string)
  }))
  default = []
}
