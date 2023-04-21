locals {
  empty = data.aws_iam_policy_document.empty.json

  templates = var.template != null ? [var.template] : var.templates
  # first check the template paths for the template. if found, apply the template
  # vars. if the template does not exist at that path, use an empty policy document
  # instead.
  policy_documents = flatten([
    for template in local.templates : [
      for path in var.template_paths : templatefile(
        "${path}/${template}",
        var.template_vars
      )
      if fileexists("${path}/${template}")
    ]
  ])
}

data "aws_iam_policy_document" "empty" {}

# use the policy document data source to merge all the policy documents, in list
# order as provided in var.template_paths. templated policies will accumulate,
# with overrides by sid.
data "aws_iam_policy_document" "this" {
  override_policy_documents = local.policy_documents
}
