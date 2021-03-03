# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM managed policies, roles, and users


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.30.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| groups | Schema list of IAM groups | <pre>list(object({<br>    name       = string<br>    path       = string<br>    user_names = list(string)<br>    inline_policies = list(object({<br>      name   = string<br>      policy = string<br>    }))<br>    managed_policies = list(object({<br>      name = string<br>      arn  = string<br>    }))<br>  }))</pre> | `[]` | no |
| policies | Schema list of policy objects | <pre>list(object({<br>    description = string<br>    name        = string<br>    path        = string<br>    policy      = string<br>  }))</pre> | `[]` | no |
| roles | Schema list of IAM roles | <pre>list(object({<br>    name                  = string<br>    assume_role_policy    = string<br>    description           = string<br>    force_detach_policies = bool<br>    instance_profile      = bool<br>    max_session_duration  = number<br>    path                  = string<br>    permissions_boundary  = string<br>    tags                  = map(string)<br>    inline_policies = list(object({<br>      name   = string<br>      policy = string<br>    }))<br>    managed_policies = list(object({<br>      name = string<br>      arn  = string<br>    }))<br>  }))</pre> | `[]` | no |
| users | Schema list of IAM users | <pre>list(object({<br>    name                 = string<br>    force_destroy        = bool<br>    path                 = string<br>    permissions_boundary = string<br>    tags                 = map(string)<br>    inline_policies = list(object({<br>      name   = string<br>      policy = string<br>    }))<br>    managed_policies = list(object({<br>      name = string<br>      arn  = string<br>    }))<br>    access_keys = list(object({<br>      name    = string<br>      status  = string<br>      pgp_key = string<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| groups | IAM group resources |
| policies | IAM managed policy resources |
| roles | IAM role resources |
| users | IAM user resources |

<!-- END TFDOCS -->
