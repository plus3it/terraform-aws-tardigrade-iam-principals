# terraform-aws-tardigrade-iam-principals//modules/policy_documents

Terraform module to merge policy document templates and apply template variables.


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
| template | Filepath to the policy document template, relative to `template_paths` | `string` | n/a | yes |
| template\_paths | List of directory paths to search for the `template` policy document. Policy statements are merged by SID in list order | `list(string)` | n/a | yes |
| template\_vars | Map of template vars to apply to the policy document | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy\_document | Rendered and templated policy document |

<!-- END TFDOCS -->
