## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_policies | Controls whether to create IAM policies | bool | `"true"` | no |
| create\_users | Controls whether an IAM user will be created | bool | `"true"` | no |
| tags | Map of tags to apply to the IAM roles | map(string) | `<map>` | no |
| template\_paths | Paths to the directories containing the templates for IAM policies and trusts | list(string) | n/a | yes |
| template\_vars | Map of input variables for IAM trust and policy templates | map(string) | `<map>` | no |
| users | Schema list of users, consisting of `name`, `policy_path`, `permission_boundary`, `policy_name`, and `inline_policy` | list | `<list>` | no |
