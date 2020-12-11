terraform {
  required_version = ">= 0.13"
}

resource "aws_iam_policy" "this" {
  name        = var.name
  policy      = var.policy
  description = var.description
  path        = var.path
}
