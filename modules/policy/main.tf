resource "aws_iam_policy" "this" {
  name        = var.name
  policy      = var.policy
  description = var.description
  path        = var.path

  tags = merge(
    {
      Name = var.name
    },
    var.tags,
  )
}
