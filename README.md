# terraform-aws-tardigrade-iam-principals

Terraform module to create IAM managed policies, roles, and users

## Testing

Manual testing:

```
# Replace "xxx" with an actual AWS profile, then execute the integration tests.
export AWS_PROFILE=xxx 
make terraform/pytest PYTEST_ARGS="-v --nomock"
```

For automated testing, PYTEST_ARGS is optional and no profile is needed:

```
make mockstack/up
make terraform/pytest PYTEST_ARGS="-v"
make mockstack/clean
```

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6 |

## Providers

No providers.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | Schema list of IAM groups | <pre>list(object({<br/>    name       = string<br/>    path       = optional(string)<br/>    user_names = optional(list(string), [])<br/>    inline_policies = optional(list(object({<br/>      name   = string<br/>      policy = string<br/>    })), [])<br/>    managed_policies = optional(list(object({<br/>      name = string<br/>      arn  = optional(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | Schema list of policy objects | <pre>list(object({<br/>    name        = string<br/>    policy      = string<br/>    description = optional(string)<br/>    path        = optional(string)<br/>    tags        = optional(map(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_policy_documents"></a> [policy\_documents](#input\_policy\_documents) | Schema list of IAM policy documents | `any` | `[]` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Schema list of IAM roles | <pre>list(object({<br/>    name                  = string<br/>    assume_role_policy    = string<br/>    description           = optional(string)<br/>    force_detach_policies = optional(bool)<br/>    instance_profile = optional(object({<br/>      name = string<br/>      path = optional(string)<br/>    }))<br/>    max_session_duration = optional(number)<br/>    path                 = optional(string)<br/>    permissions_boundary = optional(string)<br/>    tags                 = optional(map(string))<br/>    inline_policies = optional(list(object({<br/>      name   = string<br/>      policy = string<br/>    })), [])<br/>    managed_policies = optional(list(object({<br/>      name = string<br/>      arn  = optional(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | Schema list of IAM users | <pre>list(object({<br/>    name                 = string<br/>    force_destroy        = optional(bool)<br/>    path                 = optional(string)<br/>    permissions_boundary = optional(string)<br/>    tags                 = optional(map(string))<br/>    inline_policies = optional(list(object({<br/>      name   = string<br/>      policy = string<br/>    })), [])<br/>    managed_policies = optional(list(object({<br/>      name = string<br/>      arn  = optional(string)<br/>    })), [])<br/>    access_keys = optional(list(object({<br/>      name    = string<br/>      status  = optional(string)<br/>      pgp_key = optional(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_groups"></a> [groups](#output\_groups) | IAM group resources |
| <a name="output_policies"></a> [policies](#output\_policies) | IAM managed policy resources |
| <a name="output_policy_documents"></a> [policy\_documents](#output\_policy\_documents) | IAM managed policy resources |
| <a name="output_roles"></a> [roles](#output\_roles) | IAM role resources |
| <a name="output_users"></a> [users](#output\_users) | IAM user resources |

<!-- END TFDOCS -->
