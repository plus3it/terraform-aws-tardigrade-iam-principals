# terraform-aws-tardigrade-iam-principals/groups

Terraform module to create IAM groups


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
| name | Name of the IAM group | `string` | n/a | yes |
| depends\_on\_policies | List of policies created in the same tfstate. Used to manage resource cycles on policy attachments and work around for\_each limitations | `list(string)` | `[]` | no |
| depends\_on\_users | List of users created in the same tfstate. Used to manage resource cycles on user membership and work around for\_each limitations | `list(string)` | `[]` | no |
| inline\_policies | Schema list of IAM User inline policies, see `policy_document` for attribute descriptions | <pre>list(object({<br>    name           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = any<br>  }))</pre> | `[]` | no |
| managed\_policies | Schema list of IAM managed policies to attach to the user, including the policy `name` and `arn` | <pre>list(object({<br>    name = string<br>    arn  = string<br>  }))</pre> | `[]` | no |
| path | Path for the group | `string` | `null` | no |
| user\_names | List of all IAM usernames to manage as members of the group | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| group | IAM group resource |
| group\_memberships | IAM group membership resources |
| inline\_policies | IAM inline policy attachment resources |
| managed\_policies | IAM managed policy attachment resources |

<!-- END TFDOCS -->
