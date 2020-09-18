locals {
  policies = { for item in var.policies : item.name => item }
}

data "external" "this" {
  for_each = toset(var.policy_names)

  program = ["python", "${path.module}/policy_document_handler.py", "-"]
  query   = { for arg, val in local.policies[each.value] : arg => jsonencode(val) }
}

data "template_file" "this" {
  for_each = toset(var.policy_names)

  template = data.external.this[each.value].result["policy"]
  vars     = local.policies[each.value].template_vars
}
