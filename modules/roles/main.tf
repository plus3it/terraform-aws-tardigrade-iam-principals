locals {
  roles = { for role in var.roles : role.name => role }

  # Construct list of inline policy maps for use with for_each
  # https://www.terraform.io/docs/configuration/functions/flatten.html#flattening-nested-structures-for-for_each
  inline_policies = flatten([
    for role in var.inline_policies : [
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

  # Construct list of inline policy maps for use with for_each
  inline_policy_ids = flatten([
    for role in var.roles : [
      for inline_policy in lookup(role, "inline_policy_names", []) : {
        id          = "${role.name}:${inline_policy}"
        role_name   = role.name
        policy_name = inline_policy
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

  policy_names = var.roles[*].name

  policies = [
    for policy in var.assume_role_policies : {
      name           = policy.name,
      template       = policy.template
      template_paths = policy.template_paths
      template_vars  = policy.template_vars
    }
  ]
}

module "inline_policy_documents" {
  source = "../policy_documents"

  policy_names = local.inline_policy_ids[*].id

  policies = [
    for policy in local.inline_policies : {
      name           = policy.id,
      template       = policy.template
      template_paths = policy.template_paths
      template_vars  = policy.template_vars
    }
  ]
}

# create the IAM roles
resource "aws_iam_role" "this" {
  for_each = local.roles

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
  for_each = { for policy in local.managed_policies : policy.id => policy }

  policy_arn = var.policy_arns[index(var.policy_arns, each.value.policy_arn)]
  role       = aws_iam_role.this[each.value.role_name].id
}

# create inline policies for the IAM roles
resource "aws_iam_role_policy" "this" {
  for_each = { for policy in local.inline_policy_ids : policy.id => policy }

  name   = each.value.policy_name
  role   = aws_iam_role.this[each.value.role_name].id
  policy = module.inline_policy_documents.policies[each.key]
}

# attach an instance profile to the IAM roles
resource "aws_iam_instance_profile" "this" {
  for_each = { for name, role in local.roles : name => role if lookup(role, "instance_profile", null) == true }

  name = aws_iam_role.this[each.key].id
  role = aws_iam_role.this[each.key].id
}
