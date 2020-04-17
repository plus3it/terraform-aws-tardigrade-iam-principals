locals {
  roles_map = { for role in var.roles : role.name => role }

  # Construct list of inline policy maps for use with for_each
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for role in var.roles : [
      for inline_policy in lookup(role, "inline_policies", []) : {
        id             = "${role.name}:${inline_policy.name}"
        role_name      = role.name
        policy_name    = inline_policy.name
        template       = inline_policy.template
        template_paths = inline_policy.template_paths
        template_vars  = inline_policy.template_vars
      }
    ]
  ])

  # Construct list of managed policy maps for use with for_each
  managed_policies = flatten([
    for role in var.roles : [
      for policy_arn in lookup(role, "policy_arns", []) : {
        id         = "${role.name}:${policy_arn}"
        role_name  = role.name
        policy_arn = policy_arn
      }
    ]
  ])
}

module "assume_role_policy_documents" {
  source = "../policy_documents"

  create_policy_documents = var.create_roles

  policies = [
    for role in var.roles : {
      name           = role.name,
      template       = role.assume_role_policy
      template_paths = role.template_paths
      template_vars  = role.template_vars
    }
  ]
}

module "inline_policy_documents" {
  source = "../policy_documents"

  create_policy_documents = var.create_roles

  policies = [
    for policy_map in local.inline_policies : {
      name           = policy_map.id,
      template       = policy_map.template
      template_paths = policy_map.template_paths
      template_vars  = policy_map.template_vars
    }
  ]
}

# create the IAM roles
resource "aws_iam_role" "this" {
  for_each = var.create_roles ? local.roles_map : {}

  name               = each.key
  assume_role_policy = module.assume_role_policy_documents.policies[each.key]

  description           = each.value.description
  force_detach_policies = each.value.force_detach_policies
  max_session_duration  = each.value.max_session_duration
  path                  = each.value.path
  permissions_boundary  = each.value.permissions_boundary != null ? var.policy_arns[index(var.policy_arns, each.value.permissions_boundary)] : null

  # Merge module-level tags with tags set in the role-schema
  tags = merge(var.tags, each.value.tags)
}

# attach managed policies to the IAM roles
resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.create_roles ? { for policy_map in local.managed_policies : policy_map.id => policy_map } : {}

  policy_arn = var.policy_arns[index(var.policy_arns, each.value.policy_arn)]
  role       = aws_iam_role.this[each.value.role_name].id
}

# create inline policies for the IAM roles
resource "aws_iam_role_policy" "this" {
  for_each = var.create_roles ? { for policy_map in local.inline_policies : policy_map.id => policy_map } : {}

  name   = each.value.policy_name
  role   = aws_iam_role.this[each.value.role_name].id
  policy = module.inline_policy_documents.policies[each.key]
}

# attach an instance profile to the IAM roles
resource "aws_iam_instance_profile" "this" {
  for_each = { for name, role in local.roles_map : name => role if var.create_roles && lookup(role, "instance_profile", null) == true }

  name = aws_iam_role.this[each.key].id
  role = aws_iam_role.this[each.key].id
}
