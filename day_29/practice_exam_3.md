# Practice Exam 3

This file contains the full 57-question set used for Day 29 Practice Exam 3, along with the correct answers.

## Questions 1-57

1. What best describes Infrastructure as Code?
   - A. Manually creating cloud resources through a console
   - B. Managing infrastructure through versioned, declarative configuration
   - C. Installing Terraform providers globally
   - D. Monitoring infrastructure after deployment
   - Correct answer: `B`

2. What is a key advantage of Terraform compared with cloud-specific tools such as AWS CloudFormation?
   - A. Terraform only works with AWS
   - B. Terraform does not use state
   - C. Terraform supports provider-based multi-cloud and service workflows
   - D. Terraform automatically fixes every drift event
   - Correct answer: `C`

3. What is the role of a Terraform provider?
   - A. Store Terraform state
   - B. Translate Terraform configuration into API calls for a platform or service
   - C. Replace the backend block
   - D. Encrypt all secrets in state
   - Correct answer: `B`

4. Where do you declare provider source addresses and version constraints?
   - A. `provider` block only
   - B. `terraform.required_providers`
   - C. `output` block
   - D. `.terraform.lock.hcl` only
   - Correct answer: `B`

5. What does `terraform init` do?
   - A. Applies resources immediately
   - B. Initializes the working directory, backend, modules, and providers
   - C. Destroys old state
   - D. Formats configuration files only
   - Correct answer: `B`

6. What is the purpose of `.terraform.lock.hcl`?
   - A. Stores resource IDs
   - B. Records selected provider versions and checksums
   - C. Stores input variables
   - D. Prevents manual cloud-console changes
   - Correct answer: `B`

7. What does `terraform init -upgrade` do?
   - A. Upgrades Terraform CLI itself
   - B. Upgrades providers/modules within allowed version constraints
   - C. Applies pending infrastructure changes
   - D. Deletes the old lock file permanently
   - Correct answer: `B`

8. What version range does `~> 1.0.0` allow?
   - A. `>= 1.0.0, < 1.1.0`
   - B. `>= 1.0.0, < 2.0.0`
   - C. `> 1.0.0 only`
   - D. Any version above `1.0.0`
   - Correct answer: `A`

9. What version range does `~> 1.0` allow?
   - A. `>= 1.0.0, < 1.1.0`
   - B. `>= 1.0.0, < 2.0.0`
   - C. Exactly `1.0.0`
   - D. Only patch versions
   - Correct answer: `B`

10. What is the normal Terraform workflow order?
    - A. `plan -> init -> validate -> apply`
    - B. `init -> validate -> plan -> apply`
    - C. `apply -> plan -> init -> validate`
    - D. `fmt -> destroy -> init -> apply`
    - Correct answer: `B`

11. What does `terraform fmt` do?
    - A. Validates provider credentials
    - B. Formats Terraform configuration files
    - C. Applies infrastructure changes
    - D. Refreshes state from remote APIs
    - Correct answer: `B`

12. What does `terraform validate` check?
    - A. Whether real cloud resources are healthy
    - B. Whether configuration is syntactically and internally valid
    - C. Whether billing is enabled
    - D. Whether a plan is safe to apply
    - Correct answer: `B`

13. What does `terraform plan` do by default?
    - A. Applies all changes
    - B. Refreshes current remote object data and proposes actions
    - C. Destroys unmanaged infrastructure
    - D. Generates provider plugins
    - Correct answer: `B`

14. What does `terraform plan -refresh=false` do?
    - A. Forces all resources to be replaced
    - B. Skips refreshing state from remote objects before planning
    - C. Deletes stale state
    - D. Imports missing resources
    - Correct answer: `B`

15. How do you apply a saved plan named `prod.tfplan`?
    - A. `terraform apply prod.tfplan`
    - B. `terraform plan prod.tfplan`
    - C. `terraform init prod.tfplan`
    - D. `terraform validate prod.tfplan`
    - Correct answer: `A`

16. What does `terraform destroy` do?
    - A. Removes Terraform configuration files
    - B. Removes Terraform-managed real infrastructure
    - C. Deletes only local state
    - D. Deletes only providers
    - Correct answer: `B`

17. What does the local backend use by default?
    - A. HCP Terraform
    - B. A local state file on disk
    - C. AWS Secrets Manager
    - D. The Terraform Registry
    - Correct answer: `B`

18. Choose TWO benefits of remote state.
    - A. Shared state for teams
    - B. Automatic cloud cost reduction
    - C. State locking when supported by the backend
    - D. No need to run `terraform init`
    - Correct answer: `A, C`

19. What is the purpose of Terraform state locking?
    - A. Prevent all manual console changes
    - B. Prevent concurrent operations from corrupting state when supported
    - C. Encrypt all outputs
    - D. Replace version constraints
    - Correct answer: `B`

20. When should `terraform force-unlock` be used?
    - A. Anytime a plan has changes
    - B. Only to unlock your own failed/stuck lock using the lock ID
    - C. Before every apply
    - D. To bypass provider errors
    - Correct answer: `B`

21. What does `terraform state rm` do?
    - A. Destroys the real resource
    - B. Removes the resource binding from state only
    - C. Imports an existing resource
    - D. Moves a resource to another address
    - Correct answer: `B`

22. What does `terraform import` do?
    - A. Generates a complete module automatically
    - B. Adds an existing real object to Terraform state
    - C. Destroys unmanaged infrastructure
    - D. Formats imported configuration
    - Correct answer: `B`

23. After `terraform import`, why might `terraform plan` still show changes?
    - A. Terraform always destroys imported resources
    - B. The written configuration may not match the real object
    - C. Import disables state refresh
    - D. Imported resources cannot be managed
    - Correct answer: `B`

24. Which command moves a resource binding from one Terraform address to another?
    - A. `terraform state rm`
    - B. `terraform state mv`
    - C. `terraform import`
    - D. `terraform refresh`
    - Correct answer: `B`

25. What is a `moved` block used for?
    - A. Declaring that an object moved addresses during refactoring
    - B. Moving a cloud resource between regions
    - C. Moving a provider plugin
    - D. Moving variables into state
    - Correct answer: `A`

26. What can a `removed` block help express?
    - A. A resource is no longer managed by this configuration
    - B. A provider should be upgraded
    - C. A variable should become sensitive
    - D. A module should always use latest version
    - Correct answer: `A`

27. Which command can inspect Terraform state or a saved plan in human-readable form?
    - A. `terraform show`
    - B. `terraform fmt`
    - C. `terraform login`
    - D. `terraform graph apply`
    - Correct answer: `A`

28. What is true about CLI workspaces?
    - A. They share one state file
    - B. Each workspace has its own state
    - C. They replace modules
    - D. They are identical to HCP Terraform workspaces
    - Correct answer: `B`

29. Which workspace cannot be deleted?
    - A. `dev`
    - B. `staging`
    - C. `default`
    - D. The newest workspace
    - Correct answer: `C`

30. What does `terraform.workspace` return?
    - A. Current provider name
    - B. Current workspace name as a string
    - C. Current backend type
    - D. Current module source
    - Correct answer: `B`

31. What is true about HCP Terraform workspaces?
    - A. They are exactly the same as CLI workspaces
    - B. They are HCP Terraform units with settings, runs, variables, and state
    - C. They only work locally
    - D. They cannot store state
    - Correct answer: `B`

32. What is a data source used for?
    - A. Creating a new managed resource
    - B. Reading information from an existing object or service
    - C. Formatting variables
    - D. Locking state
    - Correct answer: `B`

33. How does a child module expose a value to its caller?
    - A. With an `output` block
    - B. With a `provider` block
    - C. With `terraform fmt`
    - D. With `.terraform.lock.hcl`
    - Correct answer: `A`

34. What is true about variable scope in child modules?
    - A. Child modules automatically inherit all parent variables
    - B. Child modules only receive passed values or defaults
    - C. Child modules cannot use variables
    - D. Parent outputs become child inputs automatically
    - Correct answer: `B`

35. For a registry module, what is the risk of omitting the `version` argument?
    - A. Terraform refuses to initialize
    - B. Terraform may select the latest available module version
    - C. The module cannot use outputs
    - D. The backend is disabled
    - Correct answer: `B`

36. Where is the `version` argument for a module supported?
    - A. Only for registry module sources
    - B. Only for local module paths
    - C. Only inside provider blocks
    - D. Only in output blocks
    - Correct answer: `A`

37. Why is `for_each` often safer than `count` for multiple similar resources?
    - A. It never stores state
    - B. It uses stable keys instead of numeric indexes
    - C. It prevents all drift
    - D. It removes the need for variables
    - Correct answer: `B`

38. What is a `dynamic` block useful for?
    - A. Generating repeated nested blocks from expressions
    - B. Dynamically installing providers
    - C. Encrypting output values
    - D. Creating workspaces automatically
    - Correct answer: `A`

39. When should `depends_on` be used?
    - A. Every time two resources exist
    - B. When Terraform cannot infer a dependency from references
    - C. Only for outputs
    - D. Only with remote state
    - Correct answer: `B`

40. What does `sensitive = true` do for a variable or output?
    - A. Encrypts the value in state
    - B. Hides the value from normal CLI output
    - C. Prevents the value from being passed to providers
    - D. Deletes the value after apply
    - Correct answer: `B`

41. Choose TWO good practices for secrets in Terraform.
    - A. Hardcode them in `.tf` files
    - B. Use a secrets manager such as Vault or cloud secrets services
    - C. Remember that sensitive values can still appear in state
    - D. Commit `terraform.tfstate` to Git
    - Correct answer: `B, C`

42. How does a resource use an aliased AWS provider named `west`?
    - A. `alias = aws.west`
    - B. `provider = aws.west`
    - C. `providers = west`
    - D. `terraform.workspace = west`
    - Correct answer: `B`

43. How do you pass an aliased provider into a module?
    - A. `providers = { aws = aws.west }`
    - B. `provider_alias = "west"`
    - C. `alias = module.aws.west`
    - D. `source = aws.west`
    - Correct answer: `A`

44. What must a child module declare if it expects aliased provider configurations?
    - A. `configuration_aliases` in `required_providers`
    - B. A backend block
    - C. A state file
    - D. A `terraform import` block
    - Correct answer: `A`

45. Choose TWO valid reasons to use multiple provider configurations.
    - A. Deploying resources to multiple regions
    - B. Avoiding all state files
    - C. Managing multiple accounts or subscriptions
    - D. Replacing `terraform init`
    - Correct answer: `A, C`

46. What does `create_before_destroy = true` do?
    - A. Creates a replacement before destroying the old object when possible
    - B. Prevents manual deletion
    - C. Ignores all drift
    - D. Deletes state before apply
    - Correct answer: `A`

47. What does `prevent_destroy = true` do?
    - A. Prevents Terraform from destroying that resource
    - B. Prevents manual deletion in the cloud console
    - C. Prevents all plans
    - D. Prevents outputs from displaying
    - Correct answer: `A`

48. What does `ignore_changes` do?
    - A. Ignores selected attribute changes when planning drift/config changes
    - B. Ignores all provider errors
    - C. Removes resources from state
    - D. Prevents workspace deletion
    - Correct answer: `A`

49. What is a custom variable validation block used for?
    - A. Checking whether a cloud API is available
    - B. Enforcing rules on input variable values
    - C. Locking the backend
    - D. Encrypting state
    - Correct answer: `B`

50. Which HCP Terraform feature helps enforce organizational rules on runs?
    - A. Policy enforcement with Sentinel or OPA
    - B. Local-only state
    - C. Manual `.tfstate` editing
    - D. Provider aliases only
    - Correct answer: `A`

51. What are HCP Terraform variable sets used for?
    - A. Sharing variables across workspaces
    - B. Replacing modules
    - C. Removing state locks
    - D. Running `terraform fmt` remotely
    - Correct answer: `A`

52. What is a speculative plan in HCP Terraform commonly used for?
    - A. Previewing changes for review without applying
    - B. Destroying resources automatically
    - C. Deleting a workspace
    - D. Importing all resources
    - Correct answer: `A`

53. What do run triggers help with in HCP Terraform?
    - A. Starting dependent workspace runs after another workspace changes
    - B. Formatting code locally
    - C. Replacing provider aliases
    - D. Turning off state storage
    - Correct answer: `A`

54. What does `terraform login` do?
    - A. Applies infrastructure to HCP Terraform
    - B. Stores API credentials for Terraform services such as HCP Terraform
    - C. Logs into AWS directly
    - D. Creates a backend bucket
    - Correct answer: `B`

55. How do you enable verbose Terraform logs?
    - A. Set `TF_LOG`
    - B. Run `terraform fmt -debug`
    - C. Add `debug = true` to every resource
    - D. Use `terraform validate -verbose`
    - Correct answer: `A`

56. What is the purpose of `terraform apply -refresh-only`?
    - A. Update Terraform state to match remote objects without proposing normal config changes
    - B. Destroy drifted infrastructure
    - C. Upgrade providers
    - D. Format state files
    - Correct answer: `A`

57. Which statement about `terraform validate` is most accurate?
    - A. It confirms deployed infrastructure is healthy
    - B. It checks configuration validity but does not contact real infrastructure for health checks
    - C. It automatically imports missing resources
    - D. It applies safe changes only
    - Correct answer: `B`
