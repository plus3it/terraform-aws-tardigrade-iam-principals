variable "create_policy_documents" {
  description = "Controls whether to process IAM policy documents"
  type        = bool
  default     = true
}

variable "policies" {
  description = "Schema list of policy objects"
  type = list(object({
    name           = string
    template       = string
    template_vars  = map(string)
    template_paths = list(string)
  }))
  default = []
}
