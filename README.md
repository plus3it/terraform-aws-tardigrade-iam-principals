# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM managed policies, roles, and users

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_policies | Controls whether to create IAM policies | bool | `"true"` | no |
| create\_roles | Controls whether to create IAM roles | bool | `"true"` | no |
| create\_users | Controls whether an IAM user will be created | bool | `"true"` | no |
| dependencies | List of dependency resources applied to `depends_on` in every resource in this module. Typically used with IAM managed policy ARNs that are managed in the same Terraform config | list(string) | `<list>` | no |
| description | Description of the roles. May also be set per-role in the role-schema | string | `"null"` | no |
| force\_destroy | When destroying these users, destroy even if they have non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed. May also be set per-user in the user-schema | bool | `"true"` | no |
| force\_detach\_policies | Force detaches any policies the roles have before destroying them. May also be set per-role in the role-schema | bool | `"true"` | no |
| max\_session\_duration | The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours. May also be set per-role in the role-schema | number | `"null"` | no |
| path | The path to the role. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html) for more information. May also be set per-role in the role-schema | string | `"null"` | no |
| permissions\_boundary | ARN of the policy that is used to set the permissions boundary for the roles. May also be set per-role in the role-schema | string | `"null"` | no |
| policies | Schema list of policy objects, consisting of `name`, `template` policy filename (relative to `template_paths`), (OPTIONAL) `description`, (OPTIONAL) `path` | object | `<list>` | no |
| roles | Schema list of IAM roles, consisting of `name`, `assume_role_policy`, `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `description` (OPTIONAL), `force_detach_polices` (OPTIONAL), `max_session_duration` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL) | object | `<list>` | no |
| tags | Map of tags to apply to the IAM roles. May also be set per-role in the role-schema | map(string) | `<map>` | no |
| template\_paths | Paths to the directories containing the IAM policy templates | list(string) | n/a | yes |
| template\_vars | Map of input variables and values for the IAM policy templates. | map(string) | `<map>` | no |
| users | Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL) | object | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | IAM managed policy resources |
| roles | IAM role resources |
| users | IAM user resources |

