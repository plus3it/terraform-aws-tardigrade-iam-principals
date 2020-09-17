# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM users


<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| inline\_policies | Schema list of IAM User inline policies | <pre>list(object({<br>    name = string<br>    inline_policies = list(object({<br>      name           = string<br>      template       = string<br>      template_paths = list(string)<br>      template_vars  = map(string)<br>    }))<br>  }))</pre> | `[]` | no |
| policy\_arns | List of all managed policy ARNs used in the users object. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| tags | Map of tags to apply to the IAM users. Merged with tags set per-user in the user-schema | `map(string)` | `{}` | no |
| users | Schema list of IAM users | <pre>list(object({<br>    name                 = string<br>    force_destroy        = bool<br>    path                 = string<br>    permissions_boundary = string<br>    tags                 = map(string)<br>    policy_arns          = list(string)<br>    inline_policy_names  = list(string)<br>    access_keys = list(object({<br>      name    = string<br>      status  = string<br>      pgp_key = string<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_keys | IAM access key resources |
| users | IAM user resources |

<!-- END TFDOCS -->
