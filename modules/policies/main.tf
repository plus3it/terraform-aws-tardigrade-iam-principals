locals {
  policies = { for policy in var.policies : policy.name => policy }
}

module "policy_documents" {
  source = "../policy_documents"

  create_policy_documents = var.create_policies

  policies     = var.policies
  policy_names = var.policy_names
}

resource "aws_iam_policy" "this" {
  for_each = toset(var.create_policies ? var.policy_names : [])

  name        = each.value
  policy      = module.policy_documents.policies[each.value]
  description = local.policies[each.value].description
  path        = local.policies[each.value].path
}
