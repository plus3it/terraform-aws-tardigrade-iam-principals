provider aws {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
  number  = false
}

module "create_users" {
  source = "../../modules/users/"
  providers = {
    aws = aws
  }

  create_users    = true
  create_policies = true
  template_paths  = ["${path.module}/templates"]
  template_vars = {
    "trusted_account" = data.aws_caller_identity.current.account_id
  }

  users = [
    {
      name          = "tardigrade-user-alpha-${random_string.this.result}"
      policy_name   = "alpha-policy"
      policy        = "policies/alpha.template.json"
      inline_policy = "inline_policies/alpha.template.json"
      path          = "/"
    },
    {
      name   = "tardigrade-user-beta-${random_string.this.result}"
      policy = "policies/beta.template.json"
      path   = "/"
    }
  ]
}
