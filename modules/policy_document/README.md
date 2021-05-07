# terraform-aws-tardigrade-iam-principals//modules/policy_documents

Terraform module to merge policy document templates and apply template variables.


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.28.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.28.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.empty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_template"></a> [template](#input\_template) | Filepath to the policy document template, relative to `template_paths` | `string` | n/a | yes |
| <a name="input_template_paths"></a> [template\_paths](#input\_template\_paths) | List of directory paths to search for the `template` policy document. Policy statements are merged by SID in list order. If the `template` does not exist at a given template\_path, an empty policy is used as a placeholder. If the `template` does not exist at *any* template\_path, this module returns empty policy | `list(string)` | n/a | yes |
| <a name="input_template_vars"></a> [template\_vars](#input\_template\_vars) | Map of template vars to apply to the policy document | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_document"></a> [policy\_document](#output\_policy\_document) | Rendered and templated policy document |

<!-- END TFDOCS -->
