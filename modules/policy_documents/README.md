# terraform-aws-tardigrade-iam-principals//modules/policy_documents

Terraform module to merge policy document templates and apply template variables.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_policy\_documents | Controls whether to process IAM policy documents | bool | `"true"` | no |
| policies | Schema list of policy objects, consisting of `name`, and `template` policy filename (relative to `template_paths`) | object | `<list>` | no |
| template\_paths | Paths to the directories containing the IAM policy templates | list(string) | n/a | yes |
| template\_vars | Map of template input variables for IAM policy templates | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | Returns a map of processed IAM policies |

