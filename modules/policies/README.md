# terraform-aws-tardigrade-iam-principals//modules/policies

Terraform module to create IAM Managed Policies.


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
| create\_policies | Controls whether to create IAM policies | `bool` | `true` | no |
| policies | Schema list of policy objects, consisting of `name`, `template` policy filename (relative to `template_paths`), (OPTIONAL) `description`, (OPTIONAL) `path` | <pre>list(object({<br>    name        = string<br>    template    = string<br>    description = string<br>    path        = string<br>  }))</pre> | `[]` | no |
| template\_paths | Paths to the directories containing the IAM policy templates | `list(string)` | `[]` | no |
| template\_vars | Map of template input variables for IAM policy templates | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | IAM managed policy resources |

<!-- END TFDOCS -->
