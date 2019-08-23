## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create\_policies | Controls whether to create IAM policies | string | `"true"` | no |
| create\_users | Controls whether an IAM user will be created | string | `"true"` | no |
| tags | Map of tags to apply to the IAM roles | map | `<map>` | no |
| template\_paths | Paths to the directories containing the templates for IAM policies and trusts | list | n/a | yes |
| template\_vars | Map of input variables for IAM trust and policy templates | map | `<map>` | no |
| users | Schema list of users, consisting of user name, policy path, and permission boundary, policy name, and policy path | list | `<list>` | no |
