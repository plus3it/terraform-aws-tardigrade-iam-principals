output "policies" {
  description = "Returns a map of processed IAM policies"
  value       = { for policy, item in data.external.this : policy => data.template_file.this[policy].rendered }
}
