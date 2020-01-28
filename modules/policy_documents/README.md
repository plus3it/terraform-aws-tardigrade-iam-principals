# terraform-aws-tardigrade-iam-principals//modules/policy_documents

Terraform module to merge policy document templates and apply template variables.


<!-- BEGIN TFDOCS -->
## Providers

| Name | Version |
|------|---------|
| external | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| template\_paths | Paths to the directories containing the IAM policy templates | `list(string)` | n/a | yes |
| create\_policy\_documents | Controls whether to process IAM policy documents | `bool` | `true` | no |
| policies | Schema list of policy objects, consisting of `name`, and `template` policy filename (relative to `template_paths`) | <pre>list(object({<br>    name     = string<br>    template = string<br>  }))<br></pre> | `[]` | no |
| template\_vars | Map of template input variables for IAM policy templates | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | Returns a map of processed IAM policies |

<!-- END TFDOCS -->
