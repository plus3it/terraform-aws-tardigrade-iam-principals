variable "template" {
  description = "Filepath to the policy document template, relative to `template_paths`"
  type        = string
}

variable "template_paths" {
  description = "List of directory paths to search for the `template` policy document. Policy statements are merged by SID in list order. If the `template` does not exist at a given template_path, an empty policy is used as a placeholder. If the `template` does not exist at *any* template_path, this module returns empty policy"
  type        = list(string)
}

variable "template_vars" {
  description = "Map of template vars to apply to the policy document"
  type        = any
  default     = {}
}
