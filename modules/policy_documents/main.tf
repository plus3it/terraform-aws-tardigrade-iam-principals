locals {
  policies_map = { for item in var.policies : item.name => item }
}

data "external" "this" {
  for_each = var.create_policy_documents ? local.policies_map : {}

  program = ["python", "${path.module}/policy_document_handler.py", "-"]
  query   = { for arg, val in each.value : arg => jsonencode(val) }
}

data "template_file" "this" {
  for_each = var.create_policy_documents ? local.policies_map : {}

  template = data.external.this[each.key].result["policy"]
  vars     = each.value.template_vars
}
