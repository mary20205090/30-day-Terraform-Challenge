# Practice Exam 5

This file contains the full 57-question set used for Day 30 Practice Exam 5, along with the correct answers.

## Questions 1-57

1. Which Terraform command initializes a working directory and installs required provider plugins?
   - A. `terraform validate`
   - B. `terraform init`
   - C. `terraform plan`
   - D. `terraform providers lock`
   - Correct answer: `B`

2. What does Terraform use state for?
   - A. To store only provider source addresses
   - B. To map configuration to real infrastructure objects
   - C. To replace all cloud provider APIs
   - D. To store only input variables
   - Correct answer: `B`

3. Which file records provider dependency selections and checksums?
   - A. `terraform.tfvars`
   - B. `terraform.tfstate.backup`
   - C. `.terraform.lock.hcl`
   - D. `backend.tf`
   - Correct answer: `C`

4. What is the main purpose of `terraform plan`?
   - A. To apply all changes automatically
   - B. To preview proposed changes before applying them
   - C. To delete unmanaged infrastructure
   - D. To format Terraform files
   - Correct answer: `B`

5. Which command checks whether Terraform configuration files are syntactically valid and internally consistent?
   - A. `terraform validate`
   - B. `terraform fmt`
   - C. `terraform graph`
   - D. `terraform output`
   - Correct answer: `A`

6. What does `terraform fmt -check` do?
   - A. Formats files automatically
   - B. Checks formatting and exits nonzero if changes are needed
   - C. Applies a saved plan file
   - D. Checks cloud resource health
   - Correct answer: `B`

7. Which statement about `terraform apply myplan.tfplan` is correct?
   - A. It creates a new plan named `myplan.tfplan`
   - B. It applies the previously saved plan file
   - C. It validates only the syntax
   - D. It deletes the plan file without applying it
   - Correct answer: `B`

8. What does `terraform destroy` do?
   - A. Removes only resources from state
   - B. Removes Terraform-managed infrastructure
   - C. Removes only local provider plugins
   - D. Removes only variable files
   - Correct answer: `B`

9. What does `terraform output` read from?
   - A. Current Terraform state
   - B. `.terraform.lock.hcl` only
   - C. Provider registry metadata only
   - D. `terraform.tfvars` only
   - Correct answer: `A`

10. What does `terraform graph` generate?
    - A. A cost estimate
    - B. A dependency graph in DOT format
    - C. A provider plugin checksum
    - D. A new state snapshot
    - Correct answer: `B`

11. Which two files are automatically loaded for variable values when present in the root module?
    - A. `terraform.tfvars` and `*.auto.tfvars`
    - B. `variables.tf` and `outputs.tf`
    - C. `.terraform.lock.hcl` and `backend.tf`
    - D. `provider.tf` and `main.tf`
    - Correct answer: `A`

12. Which input value source has higher precedence?
    - A. A variable default
    - B. A value passed with `-var`
    - C. A value in `terraform.tfvars`
    - D. A type constraint
    - Correct answer: `B`

13. What does a `variable` block define?
    - A. A reusable named expression inside a module
    - B. An input value accepted by a module
    - C. A provider plugin
    - D. A resource dependency graph
    - Correct answer: `B`

14. What does a `locals` block define?
    - A. Input values from callers
    - B. Reusable named expressions inside the current module
    - C. Backend configuration
    - D. Provider installation rules
    - Correct answer: `B`

15. Which expression references the current Terraform workspace name?
    - A. `workspace.current`
    - B. `terraform.workspace`
    - C. `var.workspace`
    - D. `local.workspace.current`
    - Correct answer: `B`

16. Which meta-argument uses stable keys from a map or set to create multiple instances?
    - A. `count`
    - B. `for_each`
    - C. `depends_on`
    - D. `lifecycle`
    - Correct answer: `B`

17. Which meta-argument creates multiple instances using numeric indexes?
    - A. `count`
    - B. `for_each`
    - C. `provider`
    - D. `backend`
    - Correct answer: `A`

18. What does a `dynamic` block generate?
    - A. Repeated nested blocks
    - B. Provider binaries
    - C. Workspace state files
    - D. Backend locks
    - Correct answer: `A`

19. When should `depends_on` usually be used?
    - A. For every resource relationship
    - B. When Terraform cannot infer a dependency from references
    - C. Only with modules from the registry
    - D. Only with the local backend
    - Correct answer: `B`

20. Which statement about `sensitive = true` is correct?
    - A. It encrypts the value in state automatically
    - B. It hides the value from normal CLI output but does not guarantee it is absent from state
    - C. It prevents providers from receiving the value
    - D. It deletes the value after apply
    - Correct answer: `B`

21. What does `terraform state rm` do?
    - A. Destroys the real infrastructure object
    - B. Removes a binding from state without destroying the real object
    - C. Moves a binding to a new address
    - D. Creates a new resource block
    - Correct answer: `B`

22. What does `terraform import` do?
    - A. Adds an existing remote object to Terraform state
    - B. Generates complete Terraform configuration automatically
    - C. Deletes unmanaged infrastructure
    - D. Moves an existing state address
    - Correct answer: `A`

23. What does `terraform state mv` do?
    - A. Removes real infrastructure
    - B. Moves a state binding from one address to another
    - C. Imports an object into every workspace
    - D. Formats state JSON
    - Correct answer: `B`

24. What does `terraform apply -replace=ADDRESS` do?
    - A. Removes the object from state only
    - B. Replaces the selected resource instance during apply
    - C. Imports the object into state
    - D. Renames the resource address only
    - Correct answer: `B`

25. What is the purpose of a `moved` block?
    - A. Declare a resource address change so Terraform can preserve the object during refactoring
    - B. Move a provider plugin to another directory
    - C. Move a backend bucket to another region
    - D. Move a workspace into HCP Terraform automatically
    - Correct answer: `A`

26. Which command is the modern replacement for routine use of `terraform taint`?
    - A. `terraform apply -replace=ADDRESS`
    - B. `terraform init -replace=ADDRESS`
    - C. `terraform state rm ADDRESS`
    - D. `terraform validate -replace=ADDRESS`
    - Correct answer: `A`

27. Which workspace cannot be deleted?
    - A. The newest workspace
    - B. The default workspace
    - C. Any workspace with variables
    - D. Any non-empty workspace
    - Correct answer: `B`

28. What is true about CLI workspaces?
    - A. They are identical to HCP Terraform workspaces
    - B. They maintain separate state for the same configuration
    - C. They remove the need for backends
    - D. They automatically create cloud accounts
    - Correct answer: `B`

29. Which backend configuration block stores state in HCP Terraform?
    - A. `terraform { cloud { ... } }`
    - B. `provider "tfe" { ... }`
    - C. `backend "hcp" { ... }`
    - D. `resource "terraform_cloud" "state" {}`
    - Correct answer: `A`

30. What does `terraform_remote_state` read?
    - A. Provider credentials from a registry
    - B. Outputs from another Terraform state
    - C. Secrets from all workspaces
    - D. The current `.terraform.lock.hcl` file
    - Correct answer: `B`

31. What is the purpose of a Terraform module?
    - A. Package and reuse Terraform configuration
    - B. Replace state locking
    - C. Store only secret values
    - D. Run `terraform apply` automatically
    - Correct answer: `A`

32. How does a child module expose values to its caller?
    - A. With input variables
    - B. With output values
    - C. With backend blocks
    - D. With provider lock files
    - Correct answer: `B`

33. What is true about child module variables?
    - A. Child modules automatically inherit all parent variables
    - B. Child modules receive values explicitly passed by the caller or defaults defined in the child
    - C. Child modules cannot define variables
    - D. Child modules can only use local values
    - Correct answer: `B`

34. For public registry modules, what does the `version` argument do?
    - A. Pins or constrains the selected module version
    - B. Selects a Terraform workspace
    - C. Selects a provider alias
    - D. Updates state format
    - Correct answer: `A`

35. What is the risk of using an unpinned registry module in production?
    - A. Terraform will never initialize
    - B. Future runs may select a newer module version unexpectedly
    - C. Terraform cannot create outputs
    - D. Providers stop working
    - Correct answer: `B`

36. What does a provider alias allow?
    - A. Multiple configurations of the same provider, such as different regions or accounts
    - B. Multiple local state files without workspaces
    - C. Multiple Terraform CLI versions
    - D. Multiple variable defaults
    - Correct answer: `A`

37. Which syntax uses an aliased provider named `west` inside a resource?
    - A. `provider = aws.west`
    - B. `alias = aws.west`
    - C. `providers = west`
    - D. `region = west`
    - Correct answer: `A`

38. How can a parent module pass an aliased provider to a child module?
    - A. `providers = { aws = aws.west }`
    - B. `alias = "west"`
    - C. `provider_alias = aws.west`
    - D. `source = aws.west`
    - Correct answer: `A`

39. What must a child module declare if it expects aliased provider configurations?
    - A. `configuration_aliases`
    - B. `backend_aliases`
    - C. `workspace_aliases`
    - D. `state_aliases`
    - Correct answer: `A`

40. Choose TWO valid reasons to use multiple provider configurations.
    - A. Deploying to multiple regions
    - B. Managing multiple accounts
    - C. Avoiding state entirely
    - D. Replacing modules
    - Correct answer: `A, B`

41. What does `create_before_destroy = true` do?
    - A. Attempts to create a replacement before destroying the current object
    - B. Prevents all manual deletion in the cloud console
    - C. Ignores all remote changes
    - D. Removes a resource from state only
    - Correct answer: `A`

42. What does `prevent_destroy = true` do?
    - A. Prevents Terraform from planning destruction of that resource
    - B. Prevents all cloud users from deleting the resource manually
    - C. Encrypts the resource in state
    - D. Prevents provider upgrades
    - Correct answer: `A`

43. What does `ignore_changes` do?
    - A. Tells Terraform to ignore selected attribute changes during planning
    - B. Disables all state refreshes
    - C. Prevents all resource replacement
    - D. Removes a resource from state
    - Correct answer: `A`

44. What does a data source do?
    - A. Reads information from an existing object or service
    - B. Always creates a managed resource
    - C. Stores provider versions
    - D. Replaces output values
    - Correct answer: `A`

45. Which statement about a resource block is correct?
    - A. It manages infrastructure through a provider
    - B. It only reads existing infrastructure and never changes it
    - C. It only stores local expressions
    - D. It defines a backend
    - Correct answer: `A`

46. What is Terraform Registry used for?
    - A. Publishing and discovering providers, modules, and policies
    - B. Storing state for all Terraform runs
    - C. Running applies automatically
    - D. Replacing HCP Terraform
    - Correct answer: `A`

47. Which statement best describes HCP Terraform variable sets?
    - A. They share variables across workspaces
    - B. They replace resource variables inside modules
    - C. They remove the need for `terraform.tfvars` in all cases
    - D. They are provider aliases
    - Correct answer: `A`

48. What is a speculative plan in HCP Terraform?
    - A. A plan usually run for review, such as on a pull request, without applying
    - B. A plan that always applies automatically
    - C. A plan that skips provider installation
    - D. A state migration command
    - Correct answer: `A`

49. What are run triggers used for in HCP Terraform?
    - A. Triggering dependent workspace runs after another workspace changes
    - B. Running `terraform fmt` locally
    - C. Deleting stale state locks
    - D. Importing all unmanaged resources
    - Correct answer: `A`

50. Which feature can enforce policy before infrastructure changes are applied in HCP Terraform or Terraform Enterprise?
    - A. Sentinel or OPA policy checks
    - B. `terraform fmt`
    - C. Provider aliases
    - D. Local variables
    - Correct answer: `A`

51. What does `terraform login` do?
    - A. Authenticates the CLI to services such as HCP Terraform
    - B. Logs into AWS directly
    - C. Creates an S3 backend bucket
    - D. Applies only remote runs
    - Correct answer: `A`

52. What is dynamic provider credentials in HCP Terraform used for?
    - A. Generating short-lived cloud credentials for runs
    - B. Storing static credentials permanently in Git
    - C. Removing provider version constraints
    - D. Creating CLI workspaces
    - Correct answer: `A`

53. Which environment variable enables Terraform logs?
    - A. `TF_LOG`
    - B. `TERRAFORM_DEBUG_ONLY`
    - C. `TF_STATE_LOCK`
    - D. `TF_WORKDIR`
    - Correct answer: `A`

54. What can `TF_LOG_PATH` do?
    - A. Write Terraform logs to a file
    - B. Change the active workspace
    - C. Select a provider version
    - D. Disable all logs
    - Correct answer: `A`

55. What does `terraform apply -refresh-only` do?
    - A. Updates Terraform state to match remote objects without normal create/update/destroy changes
    - B. Forces resource replacement
    - C. Upgrades provider selections
    - D. Formats the state file
    - Correct answer: `A`

56. Why should `terraform.tfstate` not be committed to version control?
    - A. It can contain sensitive values and environment-specific resource data
    - B. Terraform cannot read state from Git
    - C. It prevents `terraform init` from working
    - D. It deletes resources automatically
    - Correct answer: `A`

57. What is the best next step immediately after a final practice exam?
    - A. Review any wrong answers briefly and consolidate known weak areas
    - B. Start learning a brand-new provider deeply
    - C. Ignore all wrong answers if the score passed
    - D. Run `terraform destroy` in every old project
    - Correct answer: `A`
