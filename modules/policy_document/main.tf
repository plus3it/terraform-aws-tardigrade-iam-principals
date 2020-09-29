terraform {
  required_version = ">= 0.12"
}

data external this {
  program = ["python", "${path.module}/policy_document_handler.py", "-"]
  query = {
    template       = jsonencode(var.template)
    template_paths = jsonencode(var.template_paths)
  }
}

data template_file this {
  template = data.external.this.result["template"]
  vars     = var.template_vars
}
