provider aws {
  region = "us-east-1"
}

module "no_create_users" {
  source = "../../modules/users/"
  providers = {
    aws = aws
  }

  create_users   = false
  template_paths = []
}
