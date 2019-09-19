provider aws {
  region = "us-east-1"
}

module "no_create_roles" {
  source = "../../modules/roles/"
  providers = {
    aws = aws
  }

  create_roles   = false
  template_paths = []
}
