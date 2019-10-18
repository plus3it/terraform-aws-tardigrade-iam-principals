provider aws {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

module "create_users" {
  source = "../../modules/users/"
  providers = {
    aws = aws
  }

  create_users    = true
  create_policies = true
  template_paths  = ["${path.module}/../templates/"]
  template_vars = {
    "trusted_account" = data.aws_caller_identity.current.account_id
  }

  users = [
    {
      name          = "tardigrade-user-alpha-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      policy        = "policies/template.json"
      inline_policy = "inline_policies/template.json"
      path          = "/"
    },
    {
      name   = "tardigrade-user-beta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      policy = "policies/template.json"
      path   = "/"
    },
    {
      name          = "tardigrade-user-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      inline_policy = "inline_policies/template.json"
      path          = "/"
    },
    {
      name = "tardigrade-role-delta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
    }
  ]
}

output "create_users" {
  value = module.create_users
}
