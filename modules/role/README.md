# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM roles


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
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | Assume role policy document for the IAM role | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM role | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the IAM role | `string` | `null` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Boolean to control whether to force detach any policies the role has before destroying it | `bool` | `null` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | Schema list of IAM Role inline policies, including `name` and `policy` | <pre>list(object({<br>    name   = string<br>    policy = string<br>  }))</pre> | `[]` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | Schema object of a role's instance profile | <pre>object({<br>    name = string<br>    path = string<br>  })</pre> | `null` | no |
| <a name="input_managed_policies"></a> [managed\_policies](#input\_managed\_policies) | Schema list of IAM managed policies to attach to the role, including the policy `name` and `arn` | <pre>list(object({<br>    name = string<br>    arn  = string<br>  }))</pre> | `[]` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | List of IAM managed policy ARNs to attach to the role | `list(string)` | `[]` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration (in seconds) to set for the role. The default is one hour. This setting can have a value from 1 hour to 12 hours | `number` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | Path for the role | `string` | `null` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | ARN of the managed policy to set as the permissions boundary for the role | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to all resources that support tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile"></a> [instance\_profile](#output\_instance\_profile) | IAM instance profile resource |
| <a name="output_roles"></a> [roles](#output\_roles) | IAM role resource |

<!-- END TFDOCS -->
