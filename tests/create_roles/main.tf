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

module "create_roles" {
  source = "../../modules/roles/"
  providers = {
    aws = aws
  }

  create_roles             = true
  create_instance_profiles = true
  template_paths           = ["${path.module}/../templates/"]
  template_vars = {
    "trusted_account" = data.aws_caller_identity.current.account_id
  }

  roles = [
    {
      name          = "tardigrade-role-alpha-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      policy        = "policies/template.json"
      inline_policy = "inline_policies/template.json"
      trust         = "trusts/template.json"
    },
    {
      name   = "tardigrade-role-beta-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      policy = "policies/template.json"
      trust  = "trusts/template.json"
    },
    {
      name          = "tardigrade-role-chi-${data.terraform_remote_state.prereq.outputs.random_string.result}"
      inline_policy = "inline_policies/template.json"
      trust         = "trusts/template.json"
    }
  ]
}

output "create_roles" {
  value = module.create_roles
}
