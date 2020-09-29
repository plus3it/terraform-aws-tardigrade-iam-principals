terraform {
  required_version = ">= 0.13"
}

module policy_document {
  source = "../policy_document"

  template       = var.template
  template_paths = var.template_paths
  template_vars  = var.template_vars
}

resource aws_iam_policy this {
  name        = var.name
  policy      = module.policy_document.policy_document
  description = var.description
  path        = var.path
}
