# terraform-aws-tardigrade-iam-principals//modules/policies

Terraform module to create IAM Managed Policies.


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
| name | Name of the IAM policy | `string` | n/a | yes |
| template | Filepath to the policy document template, relative to `template_paths` | `string` | n/a | yes |
| template\_paths | List of directory paths to search for the `template` policy document. Policy statements are merged by SID in list order | `list(string)` | n/a | yes |
| description | Description for the IAM policy | `string` | `null` | no |
| path | Path for the IAM policy | `string` | `null` | no |
| template\_vars | Map of template vars to apply to the policy document | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy | IAM managed policy object |

<!-- END TFDOCS -->
