output policy_document {
  description = "Rendered and templated policy document"
  value       = data.template_file.this.rendered
}
