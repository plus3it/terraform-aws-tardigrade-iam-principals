# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM managed policies, roles, and users


<!-- BEGIN TFDOCS -->
## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| description | Description of the roles. May also be set per-role in the role-schema | `string` | n/a | yes |
| template\_paths | Paths to the directories containing the IAM policy templates | `list(string)` | n/a | yes |
| create\_policies | Controls whether to create IAM policies | `bool` | `true` | no |
| create\_roles | Controls whether to create IAM roles | `bool` | `true` | no |
| create\_users | Controls whether an IAM user will be created | `bool` | `true` | no |
| policies | Schema list of policy objects, consisting of `name`, `template` policy filename (relative to `template_paths`), (OPTIONAL) `description`, (OPTIONAL) `path` | <pre>list(object({<br>    name        = string<br>    template    = string<br>    description = string<br>    path        = string<br>  }))<br></pre> | `[]` | no |
| policy\_arns | List of all managed policy ARNs used in the roles and users objects. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| roles | Schema list of IAM roles, consisting of `name`, `assume_role_policy`, `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `description` (OPTIONAL), `force_detach_policies` (OPTIONAL), `instance_profile` (OPTIONAL), `max_session_duration` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL) | <pre>list(object({<br>    name                  = string<br>    assume_role_policy    = string<br>    description           = string<br>    force_detach_policies = bool<br>    instance_profile      = bool<br>    max_session_duration  = number<br>    path                  = string<br>    permissions_boundary  = string<br>    tags                  = map(string)<br>    policy_arns           = list(string)<br>    inline_policies = list(object({<br>      name     = string<br>      template = string<br>    }))<br>  }))<br></pre> | `[]` | no |
| tags | Map of tags to apply to the IAM roles and users. May also be set per-role/user in the role/user-schemas | `map(string)` | `{}` | no |
| template\_vars | Map of input variables and values for the IAM policy templates. | `map(string)` | `{}` | no |
| users | Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `access_keys` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL) | <pre>list(object({<br>    name                 = string<br>    force_destroy        = bool<br>    path                 = string<br>    permissions_boundary = string<br>    tags                 = map(string)<br>    policy_arns          = list(string)<br>    inline_policies = list(object({<br>      name     = string<br>      template = string<br>    }))<br>    access_keys = list(object({<br>      name    = string<br>      status  = string<br>      pgp_key = string<br>    }))<br>  }))<br></pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | IAM access key resources |
| policies | IAM managed policy resources |
| roles | IAM role resources |
| users | IAM user resources |

<!-- END TFDOCS -->
