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

locals {
  policies = [
    {
      name   = "tardigrade-alpha-${local.test_id}"
      policy = module.policy_documents["tardigrade-alpha-${local.test_id}"].policy_document
    },
    {
      name   = "tardigrade-beta-${local.test_id}"
      policy = module.policy_documents["tardigrade-beta-${local.test_id}"].policy_document
      path   = "/tardigrade/"
    },
    {
      name        = "tardigrade-chi-${local.test_id}"
      policy      = module.policy_documents["tardigrade-chi-${local.test_id}"].policy_document
      description = "tardigrade-chi-${local.test_id}"
    },
    {
      name        = "tardigrade-delta-${local.test_id}"
      policy      = module.policy_documents["tardigrade-delta-${local.test_id}"].policy_document
      description = "tardigrade-delta-${local.test_id}"
      path        = "/tardigrade/"
    },
  ]

  policy_documents = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json"
      template_vars = merge(
        local.template_vars_base,
        {
          account_id = "foo"
        }
      )
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-chi-${local.test_id}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-delta-${local.test_id}"
      template = "policies/complex_object.json.hcl.tpl"
      template_vars = merge(
        local.template_vars_base,
        {
          allowed_regions = [
            "us-east-1",
            "us-east-2"
          ]
          instance_arns = [
            "arn:${local.partition}:ec2:${local.region}:${local.account_id}:instance/*",
            "arn:${local.partition}:ec2:${local.region}:${local.account_id}:instance/i-${local.random_string}"
          ]
        }
      )
    },
  ]

  policy_base = {
    path        = null
    description = null
  }

  policy_document_base = {
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/"
    ]
  }

  template_vars_base = {
    account_id    = local.account_id
    partition     = local.partition
    region        = local.region
    random_string = local.random_string
  }
}

locals {
  test_id = data.terraform_remote_state.prereq.outputs.random_string.result

  account_id    = data.aws_caller_identity.current.account_id
  partition     = data.aws_partition.current.partition
  region        = data.aws_region.current.name
  random_string = random_string.this.result
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
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
