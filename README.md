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
| assume\_role\_policies | Schema list of assume role policy objects for the IAM Roles | <pre>list(object({<br>    name           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = map(string)<br>  }))</pre> | `[]` | no |
| create\_groups | Controls whether to create IAM groups | `bool` | `true` | no |
| create\_policies | Controls whether to create IAM policies | `bool` | `true` | no |
| create\_roles | Controls whether to create IAM roles | `bool` | `true` | no |
| create\_users | Controls whether an IAM user will be created | `bool` | `true` | no |
| groups | Schema list of IAM groups | <pre>list(object({<br>    name                = string<br>    path                = string<br>    policy_arns         = list(string)<br>    user_names          = list(string)<br>    inline_policy_names = list(string)<br>  }))</pre> | `[]` | no |
| inline\_policies | Schema list of inline policies for groups, users, and roles | <pre>list(object({<br>    name = string<br>    type = string<br>    inline_policies = list(object({<br>      name           = string<br>      template       = string<br>      template_paths = list(string)<br>      template_vars  = map(string)<br>    }))<br>  }))</pre> | `[]` | no |
| policies | Schema list of policy objects | <pre>list(object({<br>    description    = string<br>    name           = string<br>    path           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = map(string)<br>  }))</pre> | `[]` | no |
| policy\_arns | List of all managed policy ARNs used in the roles, groups, and users objects. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| policy\_names | List of policy names in the `policies` objects | `list(string)` | `[]` | no |
| roles | Schema list of IAM roles | <pre>list(object({<br>    name                  = string<br>    description           = string<br>    force_detach_policies = bool<br>    instance_profile      = bool<br>    max_session_duration  = number<br>    path                  = string<br>    permissions_boundary  = string<br>    tags                  = map(string)<br>    policy_arns           = list(string)<br>    inline_policy_names   = list(string)<br>  }))</pre> | `[]` | no |
| tags | Map of tags to apply to the IAM roles and users. May also be set per-role/user in the role/user-schemas | `map(string)` | `{}` | no |
| user\_names | List of all IAM user names used in the groups object. This is needed to properly order group membership attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| users | Schema list of IAM users | <pre>list(object({<br>    name                 = string<br>    force_destroy        = bool<br>    path                 = string<br>    permissions_boundary = string<br>    tags                 = map(string)<br>    policy_arns          = list(string)<br>    inline_policy_names  = list(string)<br>    access_keys = list(object({<br>      name    = string<br>      status  = string<br>      pgp_key = string<br>    }))<br>  }))</pre> | `[]` | no |

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
