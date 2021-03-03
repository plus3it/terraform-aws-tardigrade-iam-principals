output "policy_document" {
  description = "Rendered and templated policy document"
  value       = data.aws_iam_policy_document.this.json
}
