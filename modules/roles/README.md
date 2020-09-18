# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM roles


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
| assume\_role\_policies | Schema list of assume role policy objects for the IAM Roles | <pre>list(object({<br>    name           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = map(string)<br>  }))</pre> | `[]` | no |
| inline\_policies | Schema list of IAM Role inline policies | <pre>list(object({<br>    name = string<br>    inline_policies = list(object({<br>      name           = string<br>      template       = string<br>      template_paths = list(string)<br>      template_vars  = map(string)<br>    }))<br>  }))</pre> | `[]` | no |
| policy\_arns | List of all managed policy ARNs used in the roles object. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| roles | Schema list of IAM roles | <pre>list(object({<br>    name                  = string<br>    description           = string<br>    force_detach_policies = bool<br>    inline_policy_names   = list(string)<br>    instance_profile      = bool<br>    max_session_duration  = number<br>    path                  = string<br>    permissions_boundary  = string<br>    policy_arns           = list(string)<br>    tags                  = map(string)<br>  }))</pre> | `[]` | no |
| tags | Map of tags to apply to the IAM roles. Merged with tags set per-role in the role-schema | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| roles | IAM role resources |

<!-- END TFDOCS -->
