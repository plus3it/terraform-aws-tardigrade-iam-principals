# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM users


<!-- BEGIN TFDOCS -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| template\_paths | Paths to the directories containing the templates for IAM policies and trusts | `list(string)` | n/a | yes |
| create\_users | Controls whether an IAM user will be created | `bool` | `true` | no |
| policy\_arns | List of all managed policy ARNs used in the users object. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| tags | Map of tags to apply to the IAM users. Merged with tags set per-user in the user-schema | `map(string)` | `{}` | no |
| template\_vars | Map of input variables for IAM trust and policy templates | `map(string)` | `{}` | no |
| users | Schema list of IAM users, consisting of `name`, `path` (OPTIONAL), `policy_arns` list (OPTIONAL), `inline_policies` schema list (OPTIONAL), `access_keys` schema list (OPTIONAL), `force_destroy` (OPTIONAL), `path` (OPTIONAL), `permissions_boundary` (OPTIONAL), `tags` (OPTIONAL) | <pre>list(object({<br>    name                 = string<br>    force_destroy        = bool<br>    path                 = string<br>    permissions_boundary = string<br>    tags                 = map(string)<br>    policy_arns          = list(string)<br>    inline_policies = list(object({<br>      name     = string<br>      template = string<br>    }))<br>    access_keys = list(object({<br>      name    = string<br>      status  = string<br>      pgp_key = string<br>    }))<br>  }))<br></pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | IAM access key resources |
| users | IAM user resources |

<!-- END TFDOCS -->
