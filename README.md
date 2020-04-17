# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM managed policies, roles, and users


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| template\_paths | Paths to the directories containing the IAM policy templates | `list(string)` | n/a | yes |
| create\_groups | Controls whether to create IAM groups | `bool` | `true` | no |
| create\_policies | Controls whether to create IAM policies | `bool` | `true` | no |
| create\_roles | Controls whether to create IAM roles | `bool` | `true` | no |
| create\_users | Controls whether an IAM user will be created | `bool` | `true` | no |
| groups | Schema list of IAM groups | <pre>list(object({<br>    name        = string<br>    path        = string<br>    policy_arns = list(string)<br>    user_names  = list(string)<br>    inline_policies = list(object({<br>      name     = string<br>      template = string<br>    }))<br>  }))</pre> | `[]` | no |
| policies | Schema list of policy objects | <pre>list(object({<br>    name        = string<br>    template    = string<br>    description = string<br>    path        = string<br>  }))</pre> | `[]` | no |
| policy\_arns | List of all managed policy ARNs used in the roles, groups, and users objects. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| roles | Schema list of IAM roles | <pre>list(object({<br>    name                  = string<br>    assume_role_policy    = string<br>    description           = string<br>    force_detach_policies = bool<br>    instance_profile      = bool<br>    max_session_duration  = number<br>    path                  = string<br>    permissions_boundary  = string<br>    tags                  = map(string)<br>    policy_arns           = list(string)<br>    inline_policies = list(object({<br>      name     = string<br>      template = string<br>    }))<br>  }))</pre> | `[]` | no |
| tags | Map of tags to apply to the IAM roles and users. May also be set per-role/user in the role/user-schemas | `map(string)` | `{}` | no |
| template\_vars | Map of input variables and values for the IAM policy templates. | `map(string)` | `{}` | no |
| user\_names | List of all IAM user names used in the groups object. This is needed to properly order group membership attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| users | Schema list of IAM users | <pre>list(object({<br>    name                 = string<br>    force_destroy        = bool<br>    path                 = string<br>    permissions_boundary = string<br>    tags                 = map(string)<br>    policy_arns          = list(string)<br>    inline_policies = list(object({<br>      name     = string<br>      template = string<br>    }))<br>    access_keys = list(object({<br>      name    = string<br>      status  = string<br>      pgp_key = string<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | IAM access key resources |
| group\_memberships | IAM group membership resources |
| groups | IAM group resources |
| policies | IAM managed policy resources |
| roles | IAM role resources |
| users | IAM user resources |

<!-- END TFDOCS -->
