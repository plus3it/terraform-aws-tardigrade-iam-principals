locals {
  roles_map = { for role in var.roles : role.name => role }

  # Construct list of inline policy maps for use with for_each
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for role in var.roles : [
      for inline_policy in lookup(role, "inline_policies", []) : {
        id          = "${role.name}:${inline_policy.name}"
        role_name   = role.name
        policy_name = inline_policy.name
        template    = inline_policy.template
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

  policies       = [for role in var.roles : { name = role.name, template = role.assume_role_policy }]
  template_paths = var.template_paths
  template_vars  = var.template_vars
}

module "inline_policy_documents" {
  source = "../policy_documents"

  create_policy_documents = var.create_roles

  policies       = [for policy_map in local.inline_policies : { name = policy_map.id, template = policy_map.template }]
  template_paths = var.template_paths
  template_vars  = var.template_vars
}

# create the IAM roles
resource "aws_iam_role" "this" {
  for_each = var.create_roles ? local.roles_map : {}

  name               = each.key
  assume_role_policy = module.assume_role_policy_documents.policies[each.key]

  # If present, use the value set in the role-schema. Otherwise, use the value
  # set at the module-level variable
  description           = lookup(each.value, "description", null) != null ? each.value.description : var.description
  force_detach_policies = lookup(each.value, "force_detach_policies", null) != null ? each.value.force_detach_policies : var.force_detach_policies
  max_session_duration  = lookup(each.value, "max_session_duration", null) != null ? each.value.max_session_duration : var.max_session_duration
  path                  = lookup(each.value, "path", null) != null ? each.value.path : var.path
  permissions_boundary  = lookup(each.value, "permissions_boundary", null) != null ? each.value.permissions_boundary : var.permissions_boundary

  # Merge module-level tags with any additional tags set in the role-schema
  tags = merge(var.tags, lookup(each.value, "tags", {}))
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
  for_each = { for name, role in local.roles_map : name => role if var.create_roles && lookup(role, "instance_profile", false) != false }

  name = aws_iam_role.this[each.key].id
  role = aws_iam_role.this[each.key].id
}
