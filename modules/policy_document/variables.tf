variable template {
  description = "Filepath to the policy document template, relative to `template_paths`"
  type        = string
}

variable template_paths {
  description = "List of directory paths to search for the `template` policy document. Policy statements are merged by SID in list order"
  type        = list(string)
}

variable template_vars {
  description = "Map of template vars to apply to the policy document"
  type        = map(string)
  default     = {}
}
