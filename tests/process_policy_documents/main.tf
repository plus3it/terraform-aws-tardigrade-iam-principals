module "policy_documents" {
  source   = "../../modules/policy_document"
  for_each = { for policy in local.policies : policy.name => merge(local.policy_base, policy) }

  template       = each.value.template
  template_paths = each.value.template_paths
  template_vars  = each.value.template_vars
}

locals {
  policies = [
    {
      name     = "tardigrade-alpha-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
      template_vars = merge(
        local.template_vars_base,
        {
          account_id = "foo"
        }
      )
    },
    {
      name     = "tardigrade-beta-${local.test_id}"
      template = "policies/template.json.hcl.tpl"
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
      template = "policies/template.json.hcl.tpl"
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

output "policy_documents" {
  value = { for name, policy in module.policy_documents : name => { policy_document = jsondecode(policy.policy_document) } }
}
