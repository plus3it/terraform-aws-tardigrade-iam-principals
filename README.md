# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM managed policies, roles, and users

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_policies | Controls whether to create IAM policies | bool | `"true"` | no |
| create\_roles | Controls whether to create IAM roles | bool | `"true"` | no |
| create\_users | Controls whether an IAM user will be created | bool | `"true"` | no |
| description | Description of the roles. May also be set per-role in the role-schema | string | `"null"` | no |
| policies | Schema list of policy objects, consisting of `name`, `template` policy filename \(relative to `template\_paths`\), \(OPTIONAL\) `description`, \(OPTIONAL\) `path` | object | `<list>` | no |
| policy\_arns | List of all managed policy ARNs used in the roles and users objects. This is needed to properly order policy attachments/detachments on resource cycles | list(string) | `<list>` | no |
| roles | Schema list of IAM roles, consisting of `name`, `assume\_role\_policy`, `policy\_arns` list \(OPTIONAL\), `inline\_policies` schema list \(OPTIONAL\), `description` \(OPTIONAL\), `force\_detach\_polices` \(OPTIONAL\), `max\_session\_duration` \(OPTIONAL\), `path` \(OPTIONAL\), `permissions\_boundary` \(OPTIONAL\), `tags` \(OPTIONAL\) | object | `<list>` | no |
| tags | Map of tags to apply to the IAM roles and users. May also be set per-role/user in the role/user-schemas | map(string) | `<map>` | no |
| template\_paths | Paths to the directories containing the IAM policy templates | list(string) | n/a | yes |
| template\_vars | Map of input variables and values for the IAM policy templates. | map(string) | `<map>` | no |
| users | Schema list of IAM users, consisting of `name`, `path` \(OPTIONAL\), `policy\_arns` list \(OPTIONAL\), `inline\_policies` schema list \(OPTIONAL\), `access\_keys` schema list \(OPTIONAL\), `force\_destroy` \(OPTIONAL\), `path` \(OPTIONAL\), `permissions\_boundary` \(OPTIONAL\), `tags` \(OPTIONAL\) | object | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | IAM access key resources |
| policies | IAM managed policy resources |
| roles | IAM role resources |
| users | IAM user resources |

