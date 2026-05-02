# Practice Exam 4

This file contains the full 57-question set used for Day 29 Practice Exam 4, along with the correct answers.

## Questions 1-57

1. Which statement best describes Terraform's desired-state model?
   - A. Terraform records what infrastructure should look like and compares it to current state
   - B. Terraform only runs shell scripts on servers
   - C. Terraform requires all resources to be manually created first
   - D. Terraform stores infrastructure only in provider plugins
   - Correct answer: `A`

2. What is one benefit of storing Terraform configuration in version control?
   - A. It removes the need for state
   - B. It creates an auditable history of infrastructure changes
   - C. It prevents all cloud outages
   - D. It automatically encrypts secrets
   - Correct answer: `B`

3. What does a `resource` block represent?
   - A. An object Terraform manages through a provider
   - B. A value printed after apply only
   - C. A provider plugin installation rule
   - D. A state backend configuration
   - Correct answer: `A`

4. What does a `data` block represent?
   - A. A resource Terraform always creates
   - B. A query for information from an existing object or service
   - C. A variable assignment file
   - D. A saved execution plan
   - Correct answer: `B`

5. Which file is automatically loaded for variable values if present in the root module directory?
   - A. `terraform.tfvars`
   - B. `outputs.tfvars`
   - C. `providers.tfstate`
   - D. `backend.auto`
   - Correct answer: `A`

6. Which command initializes backend configuration and downloads required providers?
   - A. `terraform fmt`
   - B. `terraform init`
   - C. `terraform show`
   - D. `terraform output`
   - Correct answer: `B`

7. Which command checks whether Terraform files are formatted correctly without rewriting them?
   - A. `terraform fmt -check`
   - B. `terraform validate -check`
   - C. `terraform plan -format`
   - D. `terraform init -fmt`
   - Correct answer: `A`

8. What does `terraform apply` do after approval?
   - A. Makes planned infrastructure changes and updates state
   - B. Only checks syntax
   - C. Only downloads providers
   - D. Deletes the backend block
   - Correct answer: `A`

9. Which command displays output values from the current state?
   - A. `terraform output`
   - B. `terraform graph`
   - C. `terraform providers mirror`
   - D. `terraform login`
   - Correct answer: `A`

10. What does `terraform graph` produce?
    - A. A dependency graph representation
    - B. A billing report
    - C. A provider version lock file
    - D. A remote backend bucket
    - Correct answer: `A`

11. Choose TWO variable definition files Terraform loads automatically when present in the root module.
    - A. `terraform.tfvars`
    - B. `variables.tfvars`
    - C. `*.auto.tfvars`
    - D. `outputs.tfvars`
    - Correct answer: `A, C`

12. Which source has higher precedence for input variable values?
    - A. A default value in `variables.tf`
    - B. A value passed with `-var` on the CLI
    - C. A value in `terraform.tfvars`
    - D. A value in `*.auto.tfvars`
    - Correct answer: `B`

13. What does an `output` block commonly do?
    - A. Exposes selected values from a module or root configuration
    - B. Installs provider plugins
    - C. Creates a local backend
    - D. Deletes unused resources
    - Correct answer: `A`

14. What does a `locals` block define?
    - A. Reusable named expressions inside a module
    - B. Variables passed from a parent module automatically
    - C. Provider version constraints
    - D. Saved state snapshots
    - Correct answer: `A`

15. What is the difference between `var.instance_type` and `local.instance_type`?
    - A. `var` refers to input variables; `local` refers to local values
    - B. They are identical
    - C. `local` values are always stored encrypted
    - D. `var` values can only be used in outputs
    - Correct answer: `A`

16. Which expression gets the value for key `prod` from map variable `environment_sizes`?
    - A. `var.environment_sizes["prod"]`
    - B. `environment_sizes.prod`
    - C. `var.environment_sizes[0]`
    - D. `local.environment_sizes("prod")`
    - Correct answer: `A`

17. Choose TWO valid Terraform collection types.
    - A. `list`
    - B. `tuple`
    - C. `folder`
    - D. `package`
    - Correct answer: `A, B`

18. What is the purpose of the `toset()` function in many `for_each` examples?
    - A. Convert a list-like value into a set of unique values suitable for iteration
    - B. Convert state into JSON
    - C. Install a module from the registry
    - D. Create a backend lock table
    - Correct answer: `A`

19. Which meta-argument creates multiple resource instances using numeric indexes?
    - A. `count`
    - B. `for_each`
    - C. `depends_on`
    - D. `lifecycle`
    - Correct answer: `A`

20. Which meta-argument creates multiple resource instances using keys from a map or set?
    - A. `count`
    - B. `for_each`
    - C. `provider`
    - D. `backend`
    - Correct answer: `B`

21. What does the `provider` meta-argument let a resource do?
    - A. Select a specific provider configuration, such as an alias
    - B. Create a new backend
    - C. Define a module version
    - D. Format the file
    - Correct answer: `A`

22. What is the purpose of `depends_on`?
    - A. Explicitly declare a dependency Terraform cannot infer
    - B. Install providers in order
    - C. Force Terraform to ignore drift
    - D. Create state snapshots
    - Correct answer: `A`

23. What does `lifecycle.ignore_changes` help with?
    - A. Ignoring selected attribute differences during planning
    - B. Removing providers from state
    - C. Preventing all applies
    - D. Automatically importing resources
    - Correct answer: `A`

24. What is the effect of `lifecycle.prevent_destroy`?
    - A. Terraform refuses plans that would destroy the protected object
    - B. Cloud console users cannot delete the object
    - C. Terraform skips state locking
    - D. Terraform creates the replacement first
    - Correct answer: `A`

25. What is the effect of `lifecycle.create_before_destroy`?
    - A. Terraform attempts to create the replacement before destroying the current object
    - B. Terraform destroys the old object first
    - C. Terraform disables provider authentication
    - D. Terraform imports existing resources
    - Correct answer: `A`

26. Which block is used to configure a Terraform backend?
    - A. `terraform { backend "s3" { ... } }`
    - B. `provider "backend" { ... }`
    - C. `resource "terraform_backend" "s3" { ... }`
    - D. `backend.tfvars { ... }`
    - Correct answer: `A`

27. Which statement about backend blocks is correct?
    - A. Backend configuration cannot use normal input variables
    - B. Backend configuration always uses output values
    - C. Backend configuration is ignored by `terraform init`
    - D. Backend configuration belongs only in child modules
    - Correct answer: `A`

28. Which backend stores state in HCP Terraform or Terraform Enterprise?
    - A. `cloud` block / HCP Terraform configuration
    - B. `local` only
    - C. `null` backend
    - D. `provider` backend
    - Correct answer: `A`

29. What does `terraform_remote_state` do?
    - A. Reads output values from another Terraform state
    - B. Imports unmanaged resources
    - C. Locks all workspaces
    - D. Generates provider requirements
    - Correct answer: `A`

30. Choose TWO risks of sharing remote state outputs too broadly.
    - A. It can expose sensitive output values
    - B. It creates tight coupling between configurations
    - C. It removes state locking
    - D. It prevents `terraform plan` from running
    - Correct answer: `A, B`

31. What is the purpose of a module?
    - A. Package and reuse Terraform configuration
    - B. Replace Terraform state
    - C. Store provider credentials only
    - D. Run shell commands after every plan
    - Correct answer: `A`

32. How does a parent module pass values into a child module?
    - A. By assigning arguments in the `module` block
    - B. By editing the child module's state file
    - C. By relying on automatic inheritance of all variables
    - D. By using `terraform fmt`
    - Correct answer: `A`

33. How does a child module return values to its caller?
    - A. With output values
    - B. With backend configuration
    - C. With `terraform login`
    - D. With provider lock files
    - Correct answer: `A`

34. What is required to use a public Terraform Registry module version constraint?
    - A. A registry module source and `version` argument
    - B. A local file path only
    - C. A state file edit
    - D. A `provider` alias
    - Correct answer: `A`

35. What is the safest production practice for module sources?
    - A. Pin module versions where supported
    - B. Always use latest
    - C. Avoid modules completely
    - D. Put secrets in module source URLs
    - Correct answer: `A`

36. What happens if you change a resource address in configuration without telling Terraform it moved?
    - A. Terraform may plan to destroy the old address and create the new one
    - B. Terraform always detects the move automatically
    - C. Terraform ignores the change
    - D. Terraform encrypts both addresses
    - Correct answer: `A`

37. Which is the preferred configuration-based way to tell Terraform about a refactor from one address to another?
    - A. `moved` block
    - B. `terraform fmt`
    - C. `terraform output`
    - D. `provider` block
    - Correct answer: `A`

38. Which command is used to manually move a state address?
    - A. `terraform state mv`
    - B. `terraform state rm`
    - C. `terraform import`
    - D. `terraform login`
    - Correct answer: `A`

39. Which command removes a binding from state without destroying the real object?
    - A. `terraform state rm`
    - B. `terraform destroy`
    - C. `terraform apply -replace`
    - D. `terraform validate`
    - Correct answer: `A`

40. Which command replaces one resource instance on the next apply?
    - A. `terraform apply -replace=ADDRESS`
    - B. `terraform state rm ADDRESS`
    - C. `terraform fmt -replace`
    - D. `terraform output -replace`
    - Correct answer: `A`

41. What does `terraform taint` historically mark a resource for?
    - A. Replacement on the next apply
    - B. Import into state
    - C. Backend migration
    - D. Provider installation
    - Correct answer: `A`

42. What is the newer preferred approach instead of `terraform taint` for one-time replacement?
    - A. `terraform apply -replace=ADDRESS`
    - B. `terraform validate -replace=ADDRESS`
    - C. `terraform fmt -replace=ADDRESS`
    - D. `terraform output -replace=ADDRESS`
    - Correct answer: `A`

43. Which environment variable enables Terraform logging?
    - A. `TF_LOG`
    - B. `TF_STATE`
    - C. `TF_BACKEND`
    - D. `TF_PROVIDER`
    - Correct answer: `A`

44. Which log level is valid for `TF_LOG`?
    - A. `TRACE`
    - B. `SILENT`
    - C. `PLANONLY`
    - D. `STATELOCK`
    - Correct answer: `A`

45. What can `TF_LOG_PATH` do?
    - A. Write Terraform logs to a file
    - B. Select a workspace
    - C. Set provider versions
    - D. Disable state refresh
    - Correct answer: `A`

46. What is an HCP Terraform project used for?
    - A. Organizing related workspaces
    - B. Creating local-only state files
    - C. Replacing Terraform modules
    - D. Running AWS CLI commands
    - Correct answer: `A`

47. What are HCP Terraform teams used for?
    - A. Managing user access and permissions
    - B. Replacing provider aliases
    - C. Generating `.tf` files
    - D. Removing state locks
    - Correct answer: `A`

48. What is the HCP Terraform private registry used for?
    - A. Sharing approved modules and providers within an organization
    - B. Storing EC2 passwords in plain text
    - C. Running `terraform destroy` automatically
    - D. Replacing the Terraform CLI
    - Correct answer: `A`

49. What is HCP Terraform drift detection used for?
    - A. Detecting when real infrastructure differs from Terraform state/configuration expectations
    - B. Formatting `.tf` files
    - C. Creating provider aliases
    - D. Deleting unused variables
    - Correct answer: `A`

50. What is dynamic provider credentials in HCP Terraform used for?
    - A. Short-lived cloud credentials for runs
    - B. Permanent static secrets in Git
    - C. Local-only Terraform state
    - D. Module version pinning
    - Correct answer: `A`

51. Which command authenticates Terraform CLI to HCP Terraform?
    - A. `terraform login`
    - B. `terraform init -login`
    - C. `terraform cloud auth`
    - D. `terraform workspace login`
    - Correct answer: `A`

52. In HCP Terraform, what is a run?
    - A. An execution of Terraform operations such as plan/apply in a workspace
    - B. A provider alias
    - C. A local module path
    - D. A Terraform variable type
    - Correct answer: `A`

53. What is a run task in HCP Terraform commonly used for?
    - A. Integrating external checks into the run workflow
    - B. Formatting local files only
    - C. Deleting state files
    - D. Creating provider plugins
    - Correct answer: `A`

54. Which statement about policy as code in Terraform Enterprise/HCP Terraform is best?
    - A. Policies can enforce rules before changes are applied
    - B. Policies replace the need for configuration
    - C. Policies only run after resources are destroyed
    - D. Policies are the same as variables
    - Correct answer: `A`

55. Which statement about Sentinel and OPA is accurate in Terraform governance?
    - A. They are policy engines that can evaluate Terraform runs
    - B. They are backend types only
    - C. They install providers
    - D. They are variable file formats
    - Correct answer: `A`

56. Which statement about sensitive Terraform values is most accurate?
    - A. Marking a value sensitive hides it from normal CLI output but does not guarantee it is absent from state
    - B. Sensitive values are never sent to providers
    - C. Sensitive values cannot be used in modules
    - D. Sensitive values delete themselves after apply
    - Correct answer: `A`

57. What should you do immediately after a practice exam?
    - A. Record wrong answers and analyze why you missed them
    - B. Ignore the score if it passed
    - C. Delete all notes
    - D. Take another exam without reviewing anything
    - Correct answer: `A`
