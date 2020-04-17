provider aws {
  region = "us-east-1"
}

module "no_create_groups" {
  source = "../../modules/groups/"

  providers = {
    aws = aws
  }

  create_groups = false
}
