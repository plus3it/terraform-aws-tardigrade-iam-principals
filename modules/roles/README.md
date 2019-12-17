# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM roles

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_roles | Controls whether to create IAM roles | bool | `"true"` | no |
| description | Description of the roles. May also be set per-role in the role-schema | string | `"null"` | no |
| force\_detach\_policies | Force detaches any policies the roles have before destroying them. May also be set per-role in the role-schema | bool | `"true"` | no |
| max\_session\_duration | The maximum session duration \(in seconds\) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours. May also be set per-role in the role-schema | number | `"null"` | no |
| path | The path to the role. See \[IAM Identifiers\]\(https://docs.aws.amazon.com/IAM/latest/UserGuide/reference\_identifiers.html\) for more information. May also be set per-role in the role-schema | string | `"null"` | no |
| permissions\_boundary | ARN of the policy that is used to set the permissions boundary for the roles. May also be set per-role in the role-schema | string | `"null"` | no |
| policy\_arns | List of all managed policy ARNs used in the roles object. This is needed to properly order policy attachments/detachments on resource cycles | list(string) | `<list>` | no |
| roles | Schema list of IAM roles, consisting of `name`, `assume\_role\_policy`, `policy\_arns` list \(OPTIONAL\), `inline\_policies` schema list \(OPTIONAL\), `description` \(OPTIONAL\), `force\_detach\_policies` \(OPTIONAL\), `max\_session\_duration` \(OPTIONAL\), `path` \(OPTIONAL\), `permissions\_boundary` \(OPTIONAL\), `tags` \(OPTIONAL\) | object | `<list>` | no |
| tags | Map of tags to apply to the IAM roles. May also be set per-role in the role-schema | map(string) | `<map>` | no |
| template\_paths | Paths to the directories containing the IAM policy templates | list(string) | n/a | yes |
| template\_vars | Map of input variables and values for the IAM policy templates. | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| roles | IAM role resources |

