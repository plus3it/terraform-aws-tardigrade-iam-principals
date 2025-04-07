module "create_groups" {
  source   = "../../modules/group"
  for_each = { for group in local.groups : group.name => merge(local.group_base, group) }

  name             = each.key
  inline_policies  = each.value.inline_policies
  managed_policies = each.value.managed_policies
  path             = each.value.path
  user_names       = each.value.user_names
}

module "policies" {
  source   = "../../modules/policy"
  for_each = { for policy in local.policies : policy.name => merge(local.policy_base, policy) }

  description = each.value.description
  name        = each.key
  path        = each.value.path
  policy      = each.value.policy
}

module "policy_documents" {
  source   = "../../modules/policy_document"
  for_each = { for policy_document in local.policy_documents : policy_document.name => merge(local.policy_document_base, policy_document) }

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

/*
  To detect resource cycles on IAM policies when adding resources to policy
  documents:

  1. apply the prereqs
  2. apply the test config
  3. uncomment the commented lines
  4. re-apply the test config

  The failure is when ALL policies are cycled, instead of just the one policy
  that is changing.
*/

/*
resource "random_string" "foo" {
  length  = 6
  upper   = false
  special = false
  numeric  = false
}
*/

locals {
  groups = [
    {
      name             = "tardigrade-group-alpha-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
      path             = "/tardigrade/alpha/"
    },
    {
      name             = "tardigrade-group-beta-${local.test_id}"
      inline_policies  = local.inline_policies
      managed_policies = local.managed_policies
    },
    {
      name             = "tardigrade-group-chi-${local.test_id}"
      managed_policies = local.managed_policies
    },
    {
      name            = "tardigrade-group-delta-${local.test_id}"
      inline_policies = local.inline_policies
    },
    {
      name = "tardigrade-group-epsilon-${local.test_id}"
    },
  ]

  policies = [
    {
      name        = "tardigrade-alpha-${local.test_id}"
      policy      = module.policy_documents["tardigrade-alpha-${local.test_id}"].policy_document
      description = "test"
    },
    {
      name   = "tardigrade-beta-${local.test_id}"
      policy = module.policy_documents["tardigrade-beta-${local.test_id}"].policy_document
      path   = "/tardigrade/"
    },
  ]

  policy_documents = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
      template_vars = merge(
        local.template_vars_base,
        {
          instance_arns = [
            "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
            "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${random_string.this.result}",
            # Do not remove! Used to detect resource cycles, see comments above.
            # "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/${random_string.foo.result}",
          ]
        }
      )
    },
    {
      name     = "tardigrade-alpha-inline-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
    {
      name     = "tardigrade-beta-inline-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
    },
  ]

  inline_policies = [
    {
      name   = "tardigrade-alpha-${local.test_id}"
      policy = module.policy_documents["tardigrade-alpha-inline-${local.test_id}"].policy_document
    },
    {
      name   = "tardigrade-beta-${local.test_id}"
      policy = module.policy_documents["tardigrade-beta-inline-${local.test_id}"].policy_document
    },
  ]

  managed_policies = [for name, object in module.policies : {
    name = name
    arn  = object.policy.arn
  }]

  policy_base = {
    path        = null
    description = null
  }

  policy_document_base = {
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/",
      "${path.module}/../resource_cycle/",
    ]
  }

  template_vars_base = {
    account_id    = data.aws_caller_identity.current.account_id
    partition     = data.aws_partition.current.partition
    region        = data.aws_region.current.name
    random_string = random_string.this.result
    instance_arns = [
      "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
    ]
  }

  group_base = {
    inline_policies  = []
    managed_policies = []
    path             = null
    user_names       = []
  }
}

locals {
  test_id = data.terraform_remote_state.prereq.outputs.random_string.result
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  numeric = false
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

output "policies" {
  value = module.policies
}

output "create_groups" {
  value = module.create_groups
}
