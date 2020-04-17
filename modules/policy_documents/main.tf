locals {
  handler_vars = {
    template_paths = join(",", var.template_paths)
  }

  policies_map = { for item in var.policies : item.name => item }
}

data "external" "this" {
  for_each = var.create_policy_documents ? local.policies_map : {}

  program = ["python", "${path.module}/policy_document_handler.py", "-"]
  query   = merge(local.handler_vars, each.value)
}

data "template_file" "this" {
  for_each = var.create_policy_documents ? local.policies_map : {}

  template = data.external.this[each.key].result["policy"]
  vars     = merge(var.template_vars, each.value.template_vars)
}
