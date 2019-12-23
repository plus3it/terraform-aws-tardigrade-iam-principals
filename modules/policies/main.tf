locals {
  policies_map = { for policy in var.policies : policy.name => policy }
}

module "policy_documents" {
  source = "../policy_documents"

  create_policy_documents = var.create_policies
  policies                = [for policy in var.policies : { name = policy.name, template = policy.template }]
  template_paths          = var.template_paths
  template_vars           = var.template_vars
}

resource "aws_iam_policy" "this" {
  for_each = var.create_policies ? local.policies_map : {}

  name        = each.key
  policy      = module.policy_documents.policies[each.key]
  description = each.value.description
  path        = each.value.path
}
