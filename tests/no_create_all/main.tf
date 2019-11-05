provider aws {
  region = "us-east-1"
}

module "no_create_all" {
  source = "../../"

  create_policies = false
  create_roles    = false
  create_users    = false

  template_paths = []
}

output "no_create_all" {
  value = module.no_create_all
}
