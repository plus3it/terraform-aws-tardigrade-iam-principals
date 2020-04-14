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
| template\_paths | Paths to the directories containing the templates for IAM policies and trusts | `list(string)` | n/a | yes |
| create\_groups | Controls whether IAM groups will be created | `bool` | `true` | no |
| groups | Schema list of IAM groups | <pre>list(object({<br>    name        = string<br>    path        = string<br>    policy_arns = list(string)<br>    user_names  = list(string)<br>    inline_policies = list(object({<br>      name     = string<br>      template = string<br>    }))<br>  }))</pre> | `[]` | no |
| policy\_arns | List of all managed policy ARNs used in the groups object. This is needed to properly order policy attachments/detachments on resource cycles | `list(string)` | `[]` | no |
| template\_vars | Map of input variables for IAM trust and policy templates | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| group\_memberships | IAM group membership resources |
| groups | IAM group resources |

<!-- END TFDOCS -->
