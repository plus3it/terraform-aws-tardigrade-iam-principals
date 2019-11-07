provider aws {
  region = "us-east-1"
}

module "policies" {
  source = "../../modules/policies/"
  providers = {
    aws = aws
  }

  create_policies = false
  policies        = []
}

output "policies" {
  value = module.policies
}
