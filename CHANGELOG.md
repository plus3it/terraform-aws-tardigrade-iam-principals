## terraform-aws-tardigrade-iam-principals Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

### 13.0.2

**Released**: 2022.08.29

**Commit Delta**: [Change from 13.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/13.0.1...13.0.2)

**Summary**:

*   Outputs policy documents at top-level, for use case where *only* policy documents
    are templated

### 13.0.1

**Released**: 2022.08.29

**Commit Delta**: [Change from 13.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/13.0.0...13.0.1)

**Summary**:

*   Minifies policy documents in validation to align with AWS API behavior

### 13.0.0

**Released**: 2022.08.22

**Commit Delta**: [Change from 12.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/12.0.0...13.0.0)

**Summary**:

*   BACKWARDS INCOMPATIBLE: Adds `tags` attribute to objects in list of `policies` in top-level module
*   Passes tags to aws_iam_policy resource
*   Supports templating policy documents in top-level module, using `policy_documents` variable
*   Ensures that the policy_document module cannot return an empty policy
*   Validates size and number of policies on groups, roles, and users

### 12.0.0

**Released**: 2022.05.16

**Commit Delta**: [Change from 11.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/11.0.1...12.0.0)

**Summary**:

*   Changes instance_profile from a boolean to an object so the name and path attributes can be set independantly from the role name.


### 11.0.1

**Released**: 2021.05.13

**Commit Delta**: [Change from 11.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/11.0.0...11.0.1)

**Summary**:

*   Adds version configs to improve tf015 compatibility.

### 11.0.0

**Released**: 2021.03.01

**Commit Delta**: [Change from 10.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/10.0.1...11.0.0)

**Summary**:

*   Uses native features in `policy_documents` module to eliminate limitaton on
    10 `template_paths`. Increases minimum version of AWS provider for `policy_documents`
    to 3.28.0. See [PR #124](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/124).
*   Manages *exclusive* attachments of managed and inline policies to IAM roles.
    This allows terraform to remove any external attachments of policies from the
    managed role. This does not yet apply to IAM users or groups. Bumps minimum
    version of AWS provider for the top-level and roles modules to 3.30.0.
    See [PR #124](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/124).

### 10.0.1

**Released**: 2021.01.15

**Commit Delta**: [Change from 10.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/10.0.0...10.0.1)

**Summary**:

*   Marks `users` output sensitive as it may contain `access_keys`.
    See [PR #120](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/120).

### 10.0.0

**Released**: 2020.12.17

**Commit Delta**: [Change from 9.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/9.0.1...10.0.0)

**Summary**:

*   Modifies all modules to accept a pure string for `policy_document` variables,
    instead of complex objects. This requires users to resolve the `policy_document`
    separately from the groups, users, and roles modules and objects. The included
    nested module, `modules/policy_document`, can be used to resolve the policy
    document using the same set of attributes as before. See [PR #111](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/111).

### 9.0.1

**Released**: 2020.09.29

**Commit Delta**: [Change from 9.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/9.0.0...9.0.1)

**Summary**:

*   Uses native features in `policy_document` module to remove dependency on external
    provider and remove deprecated `template_file` provider. See [PR #104](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/104).

### 9.0.0

**Released**: 2020.09.29

**Commit Delta**: [Change from 8.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/8.0.0...9.0.0)

**Summary**:

*   Relies on module-level `for_each` throughout to create multiples of resources.
    See [PR #100](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/100).
*   Bumps minimum terraform version to 0.13

### 8.0.0

**Released**: 2020.09.18

**Commit Delta**: [Change from 7.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/7.0.0...8.0.0)

**Summary**:

*   Removes the `create_*` variables, relying on terraform 0.13 and module-level
    `for_each` for equivalent functionality. See [PR #99](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/99).

### 7.0.0

**Released**: 2020.07.15

**Commit Delta**: [Change from 6.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/6.0.0...7.0.0)

**Summary**:

*   Separates `policy_documents` attributes from `policies` variable to avoid resource
    cycles. See [PR #95](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/95).

### 6.0.0

**Released**: 2020.05.05

**Commit Delta**: [Change from 5.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/5.0.0...6.0.0)

**Summary**:

*   Uses separate variables where `template_vars` is needed in objects. See
    [PR #78](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/78).

### 5.0.0

**Released**: 2020.04.17

**Commit Delta**: [Change from 4.1.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/4.1.0...5.0.0)

**Summary**:

*   Moves `template_paths` and `template_vars` into the policy object for all modules. See
    [PR #73](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/73).
*   `roles` module
    *   Renames `assume_role_policy` in the role object to `assume_role_template` to reflect
    that this is indeed a template
    *   Adds `assume_role_template_paths` and `assume_role_template_vars` to allow different
    paths/vars for the assume_role_template than what was applied to policies.

### 4.1.0

**Released**: 2020.04.15

**Commit Delta**: [Change from 4.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/4.0.1...4.1.0)

**Summary**:

*   Adds a `groups` module for managing IAM Groups and group membership. See
    [PR #72](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/72).

### 4.0.4

**Released**: 2020.01.24

**Commit Delta**: [Change from 4.0.3 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/4.0.3...4.0.4)

**Summary**:

*   Improves `policy_document` handling, avoiding an edge case with lookup reference errors. See
    [PR #47](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/47).

### 4.0.3

**Released**: 2020.01.21

**Commit Delta**: [Change from 4.0.2 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/4.0.2...4.0.3)

**Summary**:

*   Handles `instance_profile = null` properly to negate the resource. See
    [PR #46](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/46).

### 4.0.2

**Released**: 2020.01.21

**Commit Delta**: [Change from 4.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/4.0.1...4.0.2)

**Summary**:

*   Adds `instance_profile` to roles object so the profile is actually created. See
    [PR #45](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/45).

### 4.0.1

**Released**: 2019.12.23

**Commit Delta**: [Change from 4.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/4.0.0...4.0.1)

**Summary**:

*   Looks up permissions boundary only when not `null`. Fixes the error:
    `Invalid value for "value" parameter: argument must not be null`. See
    [PR #40](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/40).

### 4.0.0

**Released**: 2019.12.23

**Commit Delta**: [Change from 3.1.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/3.1.0...4.0.0)

**Summary**:

*   **WARNING**: This release renames the `dependencies` variable to `policy_arns`,
    as policy attachments are the only resource in the module that can cause race
    conditions requiring explicit dependency management.
*   **WARNING**: This release deprecates and removes module-level variables used to
    set role and user attributes. These variables were used to set default values
    that would be applied to every role and user. However, because this module uses
    objects for the role and user schemas, all those attributes were required to
    be set in each role/user object anyway. That made the module-level variables
    duplicative and the supporting code was overly complicated. Instead, to set
    default values in the same way, define an object with the defaults and merge
    the default object into each role and user object. See the `tests/` directory
    for examples.
*   The `policy_arns` variable improves dependency handling during replacing updates
    of policies, as it is used directly (and only) as an attribute in the role/user
    policy attachment. Because it is not used in the `for_each` expressions, users
    can pass the output of another resource to `policy_arns`. Being used as an attribute
    is how Terraform establishes the tree for dependency ordering. See [PR #38](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/pull/38).

### 3.1.0

**Released**: 2019.12.16

**Commit Delta**: [Change from 3.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/3.0.0...3.1.0)

**Summary**:

*   Adds support for managing IAM user access keys

### 3.0.0

**Released**: 2019.11.5

**Commit Delta**: [Change from 2.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/2.0.1...3.0.0)

**Summary**:

*   **WARNING**: This is a near-complete rewrite. Resources in a Terraform state
    that were created with a prior version will need to be moved (or removed and
    imported).
*   Publishes a `policy_documents` module for merging templates of policy document
    files from an arbitrary number of `template_paths`. The module will also resolve
    any template variables using the `template_vars` map.
*   Publishes a `policies` module that creates IAM Managed Policies.
*   Updates the `roles` and `users` modules to support all of the arguments of
    their respective resources (`aws_iam_role` and `aws_iam_user`). This includes
    multiple managed and inline policies per role/user.
*   Publishes a repo-level module to simplify access to nested modules. The repo-level
    module simply passes vars through to the respective nested module.
*   Uses Terraform objects for all schema-list arguments (E.g. `users`) to provide
    better hints about the supported structure/keys of the schema.

### 2.0.1

**Released**: 2019.10.28

**Commit Delta**: [Change from 2.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/2.0.0...2.0.1)

**Summary**:

*   Pins tfdocs-awk version
*   Updates documentation generation make targets

### 2.0.0

**Released**: 2019.10.18

**Commit Delta**: [Change from 1.0.3 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/1.0.3...2.0.0)

**Summary**:

*   **WARNING**: Uses `for_each` instead of `count` on all resources. This causes
    a resource cycle on any resources created in a prior version.
*   Makes `policy` an optional key in the user and role variables.
*   Creates an inline policy _only_ if the `inline_policy` key is specified. (Previously,
    an inline policy was always created, and was a duplicate of `policy` if `inline_policy`
    was absent.)
*   Makes `path` an optional key for the users module

### 1.0.3

**Released**: 2019.10.03

**Commit Delta**: [Change from 1.0.2 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/1.0.2...1.0.3)

**Summary**:

*   Update testing harness to have a more user-friendly output
*   Update terratest dependencies

### 1.0.2

**Released**: 2019.09.27

**Commit Delta**: [Change from 1.0.1 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/1.0.1...1.0.2)

**Summary**:

*   Change toggle variables to be explicitly booleans
*   Update documentation

### 1.0.1

**Released**: 2019.09.27

**Commit Delta**: [Change from 1.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/1.0.0...1.0.1)

**Summary**:

*   Fix typos in conditionals

### 1.0.0

**Released**: 2019.09.19

**Commit Delta**: [Change from 0.0.0 release](https://github.com/plus3it/terraform-aws-tardigrade-iam-principals/compare/0.0.0...1.0.0)

**Summary**:

*   Upgrade to terraform 0.12.x
*   Add test cases

### 0.0.0

**Commit Delta**: N/A

**Released**: 2019.08.23

**Summary**:

*   Initial release!
