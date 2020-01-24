output "policies" {
  description = "Returns a map of processed IAM policies"
  value       = { for policy, item in data.template_file.this : policy => item.rendered }
}
