# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM users

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_users | Controls whether an IAM user will be created | bool | `"true"` | no |
| dependencies | List of dependency resources applied to `depends_on` in every resource in this module. Typically used with IAM managed policy ARNs that are managed in the same Terraform config | list(string) | `<list>` | no |
| force\_destroy | When destroying these users, destroy even if they have non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed. May also be set per-user in the user-schema | bool | `"true"` | no |
| path | The path to the user. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html) for more information. May also be set per-user in the user-schema | string | `"null"` | no |
| permissions\_boundary | ARN of the policy that is used to set the permissions boundary for the users. May also be set per-user in the user-schema | string | `"null"` | no |
| tags | Map of tags to apply to the IAM roles | map(string) | `<map>` | no |
| template\_paths | Paths to the directories containing the templates for IAM policies and trusts | list(string) | n/a | yes |
| template\_vars | Map of input variables for IAM trust and policy templates | map(string) | `<map>` | no |
| users | Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL) | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| users | IAM user resources |

