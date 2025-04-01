module "policy_documents_1" {
  source   = "../../modules/policy_document"
  for_each = { for policy in local.policies_1 : policy.name => merge(local.policy_base, policy) }

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

module "policy_documents_2" {
  source   = "../../modules/policy_document"
  for_each = { for policy in local.policies_2 : policy.name => merge(local.policy_base, policy) }

  templates      = each.value.templates
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

locals {
  policies_1 = [
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
      name     = "tardigrade-charlie-${local.test_id}"
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
    {
      name     = "tardigrade-delta-${local.test_id}"
      template = "policies/template.json"
      template_paths = concat(
        local.policy_base.template_paths,
        [
          "${path.module}/override/"
        ]
      )
    },
  ]

  policies_2 = [
    {
      name      = "tardigrade-alpha-${local.test_id}"
      templates = ["policies/template.json", "policies/template_2.json"]
      template_vars = merge(
        local.template_vars_base,
        {
          account_id = "foo"
        }
      )
    },
    {
      name      = "tardigrade-beta-${local.test_id}"
      templates = ["policies/template.json", "policies/template_2.json"]
    },
    {
      name      = "tardigrade-charlie-${local.test_id}"
      templates = ["policies/complex_object.json.hcl.tpl", "policies/complex_object_2.json.hcl.tpl"]
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
    {
      name      = "tardigrade-delta-${local.test_id}"
      templates = ["policies/template.json", "policies/template_2.json"]
      template_paths = concat(
        local.policy_base.template_paths,
        [
          "${path.module}/override/"
        ]
      )
    },
  ]

  policy_base = {
    template_vars = local.template_vars_base
    template_paths = [
      "${path.module}/../templates/",
      "${path.module}/fake/path/",
    ]
  }

  template_vars_base = {
    account_id    = local.account_id
    partition     = local.partition
    region        = local.region
    random_string = local.random_string
    instance_arns = [
      "arn:${local.partition}:ec2:${local.region}:${local.account_id}:instance/*"
    ]
  }
}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  numeric = false
}

locals {
  test_id = data.terraform_remote_state.prereq.outputs.random_string.result

  account_id    = data.aws_caller_identity.current.account_id
  partition     = data.aws_partition.current.partition
  region        = data.aws_region.current.name
  random_string = random_string.this.result
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

output "policy_document_1" {
  value = { for name, policy in module.policy_documents_1 : name => { policy_document = jsondecode(policy.policy_document) } }
}
