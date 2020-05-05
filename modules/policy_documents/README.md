# terraform-aws-tardigrade-iam-principals//modules/policy_documents

Terraform module to merge policy document templates and apply template variables.


<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| external | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_policy\_documents | Controls whether to process IAM policy documents | `bool` | `true` | no |
| policies | Schema list of policy objects | <pre>list(object({<br>    name           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = map(string)<br>  }))</pre> | `[]` | no |
| policy\_names | List of policy names in the `policies` objects | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | Returns a map of processed IAM policies |

<!-- END TFDOCS -->
