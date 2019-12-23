# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM users

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_users | Controls whether an IAM user will be created | bool | `"true"` | no |
| policy\_arns | List of all managed policy ARNs used in the users object. This is needed to properly order policy attachments/detachments on resource cycles | list(string) | `<list>` | no |
| tags | Map of tags to apply to the IAM users. Merged with tags set per-user in the user-schema | map(string) | `<map>` | no |
| template\_paths | Paths to the directories containing the templates for IAM policies and trusts | list(string) | n/a | yes |
| template\_vars | Map of input variables for IAM trust and policy templates | map(string) | `<map>` | no |
| users | Schema list of IAM users, consisting of `name`, `path` \(OPTIONAL\), `policy\_arns` list \(OPTIONAL\), `inline\_policies` schema list \(OPTIONAL\), `access\_keys` schema list \(OPTIONAL\), `force\_destroy` \(OPTIONAL\), `path` \(OPTIONAL\), `permissions\_boundary` \(OPTIONAL\), `tags` \(OPTIONAL\) | object | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | IAM access key resources |
| users | IAM user resources |

