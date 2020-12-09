# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM roles


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
| assume\_role\_policy | Schema map of attributes for the assume role policy, see `policy_document` for attribute descriptions | <pre>object({<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = any<br>  })</pre> | n/a | yes |
| name | Name of the IAM role | `string` | n/a | yes |
| depends\_on\_policies | List of policies created in the same tfstate. Used to manage resource cycles on policy attachments and work around for\_each limitations | `list(string)` | `[]` | no |
| description | Description of the IAM role | `string` | `null` | no |
| force\_detach\_policies | Boolean to control whether to force detach any policies the role has before destroying it | `bool` | `null` | no |
| inline\_policies | Schema list of IAM User inline policies, see `policy_document` for attribute descriptions | <pre>list(object({<br>    name           = string<br>    template       = string<br>    template_paths = list(string)<br>    template_vars  = any<br>  }))</pre> | `[]` | no |
| instance\_profile | Boolean to control whether to create an instance profile for the role | `bool` | `false` | no |
| managed\_policies | Schema list of IAM managed policies to attach to the user, including the policy `name` and `arn` | <pre>list(object({<br>    name = string<br>    arn  = string<br>  }))</pre> | `[]` | no |
| max\_session\_duration | Maximum session duration (in seconds) to set for the role. The default is one hour. This setting can have a value from 1 hour to 12 hours | `number` | `null` | no |
| path | Path for the role | `string` | `null` | no |
| permissions\_boundary | ARN of the managed policy to set as the permissions boundary for the user | `string` | `null` | no |
| tags | Map of tags to apply to all resources that support tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| inline\_policies | IAM inline policy attachment resources |
| instance\_profile | IAM instance profile resource |
| managed\_policies | IAM managed policy attachment resources |
| roles | IAM role resource |

<!-- END TFDOCS -->
