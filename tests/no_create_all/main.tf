module "no_create_all" {
  source = "../../"
  count  = 0
}

output "no_create_all" {
  value = module.no_create_all
}
