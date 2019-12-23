## terraform-aws-tardigrade-iam-principals Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

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
