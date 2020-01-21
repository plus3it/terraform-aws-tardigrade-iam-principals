# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM roles

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_roles | Controls whether to create IAM roles | bool | `"true"` | no |
| policy\_arns | List of all managed policy ARNs used in the roles object. This is needed to properly order policy attachments/detachments on resource cycles | list(string) | `<list>` | no |
| roles | Schema list of IAM roles, consisting of `name`, `assume\_role\_policy`, `policy\_arns` list \(OPTIONAL\), `inline\_policies` schema list \(OPTIONAL\), `description` \(OPTIONAL\), `force\_detach\_policies` \(OPTIONAL\), `instance\_profile` \(OPTIONAL\), `max\_session\_duration` \(OPTIONAL\), `path` \(OPTIONAL\), `permissions\_boundary` \(OPTIONAL\), `tags` \(OPTIONAL\) | object | `<list>` | no |
| tags | Map of tags to apply to the IAM roles. Merged with tags set per-role in the role-schema | map(string) | `<map>` | no |
| template\_paths | Paths to the directories containing the IAM policy templates | list(string) | n/a | yes |
| template\_vars | Map of input variables and values for the IAM policy templates. | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| roles | IAM role resources |

