output "policy_document" {
  description = "Rendered and templated policy document"
  value       = data.aws_iam_policy_document.this.json

  precondition {
    condition     = data.aws_iam_policy_document.this.json != local.empty
    error_message = "Policy resolved to an empty document, which is never valid. Ensure the provided `template` exists in at least one `template_paths` location. templates = ${jsonencode(local.templates)}. template_paths = ${jsonencode(var.template_paths)}."
  }
}
