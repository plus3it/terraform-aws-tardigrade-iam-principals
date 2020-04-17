provider aws {
  region = "us-east-1"
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

module "policy_documents" {
  source = "../../modules/policy_documents/"
  providers = {
    aws = aws
  }

  template_paths = ["${path.module}/../templates/"]
  template_vars = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  policies = [for policy in local.policies : merge(local.policy_base, policy)]
}

locals {
  policies = [
    {
      name     = "tardigrade-alpha-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template = "policies/template.json"
      template_vars = {
        account_id = "foo"
      }
    },
    {
      name     = "tardigrade-beta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template = "policies/template.json"
    },
  ]

  policy_base = {
    path        = null
    description = null
    template_vars = {
      partition = "aws-us-gov"
      region    = "us-gov-west-1"
    }
  }
}

output "policies" {
  value = module.policy_documents
}
