# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM users


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the IAM user | `string` | n/a | yes |
| access\_keys | Schema list of IAM access key attributes, including the access key `name`, `status`, and `pgp_key` | <pre>list(object({<br>    name    = string<br>    status  = string<br>    pgp_key = string<br>  }))</pre> | `[]` | no |
| force\_destroy | When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without `force_destroy` a user with non-Terraform-managed access keys and login profile will fail to be destroyed | `bool` | `null` | no |
| inline\_policies | Schema list of IAM User inline policies, see `policy_document` for attribute descriptions | <pre>list(object({<br>    name           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = map(string)<br>  }))</pre> | `[]` | no |
| managed\_policies | Schema list of IAM managed policies to attach to the user, including the policy `name` and `arn` | <pre>list(object({<br>    name = string<br>    arn  = string<br>  }))</pre> | `[]` | no |
| path | Path for the user | `string` | `null` | no |
| permissions\_boundary | ARN of the managed policy to set as the permissions boundary for the user | `string` | `null` | no |
| tags | Map of tags to apply to all resources that support tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | IAM access key resources |
| inline\_policies | IAM inline policy attachment resources |
| managed\_policies | IAM managed policy attachment resources |
| user | IAM user resource |

<!-- END TFDOCS -->
