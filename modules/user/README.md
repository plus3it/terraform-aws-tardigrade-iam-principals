# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM users


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM user | `string` | n/a | yes |
| <a name="input_access_keys"></a> [access\_keys](#input\_access\_keys) | Schema list of IAM access key attributes, including the access key `name`, `status`, and `pgp_key` | <pre>list(object({<br/>    name    = string<br/>    status  = string<br/>    pgp_key = string<br/>  }))</pre> | `[]` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without `force_destroy` a user with non-Terraform-managed access keys and login profile will fail to be destroyed | `bool` | `null` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | Schema list of IAM User inline policies, including `name` and `policy` | <pre>list(object({<br/>    name   = string<br/>    policy = string<br/>  }))</pre> | `[]` | no |
| <a name="input_managed_policies"></a> [managed\_policies](#input\_managed\_policies) | Schema list of IAM managed policies to attach to the user, including the policy `name` and `arn` | <pre>list(object({<br/>    name = string<br/>    arn  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_path"></a> [path](#input\_path) | Path for the user | `string` | `null` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | ARN of the managed policy to set as the permissions boundary for the user | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to all resources that support tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_keys"></a> [access\_keys](#output\_access\_keys) | IAM access key resources |
| <a name="output_inline_policies"></a> [inline\_policies](#output\_inline\_policies) | IAM inline policy attachment resources |
| <a name="output_managed_policies"></a> [managed\_policies](#output\_managed\_policies) | IAM managed policy attachment resources |
| <a name="output_user"></a> [user](#output\_user) | IAM user resource |

<!-- END TFDOCS -->
