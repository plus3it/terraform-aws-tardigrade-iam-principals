# select the policy document to return, based on the number of template_paths provided. due to the
# way policy documents are merged in the data sources, the policy document will be in the data source
# that matches the length of the list.
output "policy_document" {
  description = "Rendered and templated policy document"
  value = (
    local.template_paths_length == 0) ? local.empty : (
    local.template_paths_length == 1) ? data.aws_iam_policy_document.one[0].json : (
    local.template_paths_length == 2) ? data.aws_iam_policy_document.two[0].json : (
    local.template_paths_length == 3) ? data.aws_iam_policy_document.three[0].json : (
    local.template_paths_length == 4) ? data.aws_iam_policy_document.four[0].json : (
    local.template_paths_length == 5) ? data.aws_iam_policy_document.five[0].json : (
    local.template_paths_length == 6) ? data.aws_iam_policy_document.six[0].json : (
    local.template_paths_length == 7) ? data.aws_iam_policy_document.seven[0].json : (
    local.template_paths_length == 8) ? data.aws_iam_policy_document.eight[0].json : (
    local.template_paths_length == 9) ? data.aws_iam_policy_document.nine[0].json : (
    data.aws_iam_policy_document.ten[0].json
  )
}
