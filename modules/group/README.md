# terraform-aws-tardigrade-iam-principals/groups

Terraform module to create IAM groups


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the IAM group | `string` | n/a | yes |
| <a name="input_depends_on_policies"></a> [depends\_on\_policies](#input\_depends\_on\_policies) | List of policies created in the same tfstate. Used to manage resource cycles on policy attachments and work around for\_each limitations | `list(string)` | `[]` | no |
| <a name="input_depends_on_users"></a> [depends\_on\_users](#input\_depends\_on\_users) | List of users created in the same tfstate. Used to manage resource cycles on user membership and work around for\_each limitations | `list(string)` | `[]` | no |
| <a name="input_inline_policies"></a> [inline\_policies](#input\_inline\_policies) | Schema list of IAM Group inline policies, including `name` and `policy` | <pre>list(object({<br>    name   = string<br>    policy = string<br>  }))</pre> | `[]` | no |
| <a name="input_managed_policies"></a> [managed\_policies](#input\_managed\_policies) | Schema list of IAM managed policies to attach to the group, including the policy `name` and `arn` | <pre>list(object({<br>    name = string<br>    arn  = string<br>  }))</pre> | `[]` | no |
| <a name="input_path"></a> [path](#input\_path) | Path for the group | `string` | `null` | no |
| <a name="input_user_names"></a> [user\_names](#input\_user\_names) | List of all IAM usernames to manage as members of the group | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group"></a> [group](#output\_group) | IAM group resource |
| <a name="output_group_memberships"></a> [group\_memberships](#output\_group\_memberships) | IAM group membership resources |
| <a name="output_inline_policies"></a> [inline\_policies](#output\_inline\_policies) | IAM inline policy attachment resources |
| <a name="output_managed_policies"></a> [managed\_policies](#output\_managed\_policies) | IAM managed policy attachment resources |

<!-- END TFDOCS -->
