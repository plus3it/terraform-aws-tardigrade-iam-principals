# terraform-aws-tardigrade-iam-principals/groups

Terraform module to create IAM groups


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
| create\_groups | Controls whether IAM groups will be created | `bool` | `true` | no |
| groups | Schema list of IAM Group objects | <pre>list(object({<br>    name                = string<br>    path                = string<br>    policy_arns         = list(string)<br>    user_names          = list(string)<br>    inline_policy_names = list(string)<br>  }))</pre> | `[]` | no |
| inline\_policies | Schema list of IAM Group inline policies | <pre>list(object({<br>    name = string<br>    inline_policies = list(object({<br>      name           = string<br>      template       = string<br>      template_paths = list(string)<br>      template_vars  = map(string)<br>    }))<br>  }))</pre> | `[]` | no |
| policy\_arns | List of all managed policy ARNs used in the groups object. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| user\_names | List of all IAM user names used in the groups object. This is needed to properly order group membership attachments/detachments on resource cycles | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| group\_memberships | IAM group membership resources |
| groups | IAM group resources |

<!-- END TFDOCS -->
