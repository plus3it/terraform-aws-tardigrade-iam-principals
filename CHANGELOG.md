## terraform-aws-tardigrade-iam-principals Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

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
