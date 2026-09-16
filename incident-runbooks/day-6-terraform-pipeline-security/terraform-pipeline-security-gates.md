# Day 6: Terraform Pipeline Security Gates

## Objective

Validate that the CI/CD pipeline blocks unsafe Terraform changes before deployment.

## Test 1: Terraform Format Failure

### Change Introduced

Misformatted Terraform block.

### Expected Result

Pipeline fails at:

```text
terraform fmt -check -recursive
```
Result:

 terraform fmt -check -recursive
  shell: /usr/bin/bash -e {0}
  env:
    AWS_REGION: ca-central-1
    TF_WORKING_DIR: terraform-aws-platform/environments/dev
    TERRAFORM_CLI_PATH: /home/runner/work/_temp/5242d5a6-964f-4589-99aa-0febedcc31fd
    AWS_DEFAULT_REGION: ca-central-1
    AWS_ACCESS_KEY_ID: ***
    AWS_SECRET_ACCESS_KEY: ***
main.tf
Error: Terraform exited with code 3.
Error: Process completed with exit code 1.

## Recovery Action

Unsafe Terraform changes were removed and the pipeline was re-run successfully.
Prevention
- Keep Checkov enabled with soft_fail: false
- Require pull requests
- Require Terraform plan review
- Use manual approval before apply
- Use branch protection
- Restrict production applies to approved reviewers