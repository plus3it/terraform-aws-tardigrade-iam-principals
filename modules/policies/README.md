# terraform-aws-tardigrade-iam-principals//modules/policies

Terraform module to create IAM Managed Policies.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_policies | Controls whether to create IAM policies | bool | `"true"` | no |
| policies | Schema list of policy objects, consisting of `name`, `template` policy filename (relative to `template_paths`), (OPTIONAL) `description`, (OPTIONAL) `path` | list(map(string)) | `<list>` | no |
| template\_paths | Paths to the directories containing the IAM policy templates | list(string) | `<list>` | no |
| template\_vars | Map of template input variables for IAM policy templates | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | IAM managed policy resources |

