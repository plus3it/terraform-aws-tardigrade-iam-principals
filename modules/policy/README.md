# terraform-aws-tardigrade-iam-principals//modules/policies

Terraform module to create IAM Managed Policies.


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM policy | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | Policy document for the IAM policy | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description for the IAM policy | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | Path for the IAM policy | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to all resources that support tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy"></a> [policy](#output\_policy) | IAM managed policy object |

<!-- END TFDOCS -->
