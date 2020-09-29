terraform {
  required_version = ">= 0.13"
}

locals {
  template_paths_length = length(var.template_paths)

  empty = data.aws_iam_policy_document.empty.json

  # first check the template paths for the template. if found, apply the template vars. if the template
  # does not exist at that path, use an empty policy document instead.
  policy_documents = [
    for path in var.template_paths : fileexists("${path}/${var.template}") ? (
      templatefile(
        "${path}/${var.template}",
        var.template_vars
      )
    ) : local.empty
  ]
}

data aws_iam_policy_document empty {}

# use the policy document data source to merge all the policy documents, in list order as provided
# in var.template_paths. this way they accumulate, with overrides by sid.
data aws_iam_policy_document one {
  count = local.template_paths_length > 0 ? 1 : 0

  source_json = local.policy_documents[0]
}

data aws_iam_policy_document two {
  count = local.template_paths_length > 1 ? 1 : 0

  source_json   = data.aws_iam_policy_document.one[0].json
  override_json = local.policy_documents[1]
}

data aws_iam_policy_document three {
  count = local.template_paths_length > 2 ? 1 : 0

  source_json   = data.aws_iam_policy_document.two[0].json
  override_json = local.policy_documents[2]
}

data aws_iam_policy_document four {
  count = local.template_paths_length > 3 ? 1 : 0

  source_json   = data.aws_iam_policy_document.three[0].json
  override_json = local.policy_documents[3]
}

data aws_iam_policy_document five {
  count = local.template_paths_length > 4 ? 1 : 0

  source_json   = data.aws_iam_policy_document.four[0].json
  override_json = local.policy_documents[4]
}

data aws_iam_policy_document six {
  count = local.template_paths_length > 5 ? 1 : 0

  source_json   = data.aws_iam_policy_document.five[0].json
  override_json = local.policy_documents[5]
}

data aws_iam_policy_document seven {
  count = local.template_paths_length > 6 ? 1 : 0

  source_json   = data.aws_iam_policy_document.six[0].json
  override_json = local.policy_documents[6]
}

data aws_iam_policy_document eight {
  count = local.template_paths_length > 7 ? 1 : 0

  source_json   = data.aws_iam_policy_document.seven[0].json
  override_json = local.policy_documents[7]
}

data aws_iam_policy_document nine {
  count = local.template_paths_length > 8 ? 1 : 0

  source_json   = data.aws_iam_policy_document.eight[0].json
  override_json = local.policy_documents[8]
}

data aws_iam_policy_document ten {
  count = local.template_paths_length > 9 ? 1 : 0

  source_json   = data.aws_iam_policy_document.nine[0].json
  override_json = local.policy_documents[9]
}
