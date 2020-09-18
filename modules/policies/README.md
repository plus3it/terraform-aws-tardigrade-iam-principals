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
| policies | Schema list of policy objects | <pre>list(object({<br>    description = string<br>    name        = string<br>    path        = string<br>  }))</pre> | `[]` | no |
| policy\_documents | Schema list of policy\_document objects | <pre>list(object({<br>    name           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = map(string)<br>  }))</pre> | `[]` | no |
| policy\_names | List of policy names in the `policies` objects | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | IAM managed policy resources |

<!-- END TFDOCS -->
