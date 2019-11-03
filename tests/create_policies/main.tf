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

module "policies" {
  source = "../../modules/policies/"
  providers = {
    aws = aws
  }

  template_paths = ["${path.module}/../templates/"]
  template_vars = {
    "account_id" = data.aws_caller_identity.current.account_id
    "partition"  = data.aws_partition.current.partition
    "region"     = data.aws_region.current.name
  }

  policies = [
    {
      name     = "tardigrade-alpha-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template = "policies/template.json"
    },
    {
      name     = "tardigrade-beta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template = "policies/template.json"
      path     = "/tardigrade/"
    },
    {
      name        = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template    = "policies/template.json"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    },
    {
      name        = "tardigrade-role-delta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      template    = "policies/template.json"
      path        = "/tardigrade/"
      description = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    },
  ]
}

output "policies" {
  value = module.policies
}
