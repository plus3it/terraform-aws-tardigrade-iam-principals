# terraform-aws-tardigrade-iam-principals//modules/policies

Terraform module to create IAM Managed Policies.


<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the IAM policy | `string` | n/a | yes |
| policy | Policy document for the IAM policy | `string` | n/a | yes |
| description | Description for the IAM policy | `string` | `null` | no |
| path | Path for the IAM policy | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy | IAM managed policy object |

<!-- END TFDOCS -->
