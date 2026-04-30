# Practice Exam 2

This file contains the full 57-question set used for Day 28 Practice Exam 2, along with the correct answers.

1. Which Terraform command downloads providers and initializes the working directory?
   - A. `terraform validate`
   - B. `terraform init`
   - C. `terraform plan`
   - D. `terraform apply`
   - Correct answer: `B`

2. What is the main purpose of `.terraform.lock.hcl`?
   - A. Store Terraform state
   - B. Record selected provider versions and checksums
   - C. Store backend credentials
   - D. Save module outputs
   - Correct answer: `B`

3. Which statement best describes Terraform?
   - A. It is an imperative scripting engine for clouds
   - B. It is a declarative Infrastructure as Code tool
   - C. It is only for AWS
   - D. It replaces all cloud APIs with HashiCorp APIs
   - Correct answer: `B`

4. Which command shows the proposed infrastructure changes without applying them?
   - A. `terraform fmt`
   - B. `terraform graph`
   - C. `terraform plan`
   - D. `terraform output`
   - Correct answer: `C`

5. What does `terraform fmt` do?
   - A. Destroys resources with invalid syntax
   - B. Formats Terraform files into canonical style
   - C. Validates provider credentials
   - D. Encrypts variable files
   - Correct answer: `B`

6. Which Terraform feature helps reduce configuration drift?
   - A. Manual console changes
   - B. Declarative desired state
   - C. Rebooting instances regularly
   - D. Provider aliases
   - Correct answer: `B`

7. What happens if a required input variable has no default and no value is supplied?
   - A. Terraform silently uses `null`
   - B. Terraform skips that resource
   - C. Terraform prompts for a value or errors in non-interactive use
   - D. Terraform uses the variable description
   - Correct answer: `C`

8. Which file is commonly used to assign variable values automatically for a root module?
   - A. `terraform.providers`
   - B. `terraform.tfvars`
   - C. `.terraform.lock.hcl`
   - D. `main.auto.lock`
   - Correct answer: `B`

9. Which of the following is a valid reason to use `locals`?
   - A. To create real infrastructure resources
   - B. To store computed values reused within a module
   - C. To replace provider blocks
   - D. To import existing infrastructure
   - Correct answer: `B`

10. Which statement about `count` is correct?
   - A. It can only be used with modules
   - B. It creates multiple instances based on a numeric value
   - C. It is only for data sources
   - D. It preserves stable keys better than `for_each`
   - Correct answer: `B`

11. Which statement about `for_each` is correct?
   - A. It only works with numbers
   - B. It cannot be used with maps
   - C. It creates instances based on keys in a map or set
   - D. It always recreates all resources when one item changes
   - Correct answer: `C`

12. Which command is most appropriate to inspect the attributes of one resource already tracked in state?
   - A. `terraform state show`
   - B. `terraform state rm`
   - C. `terraform import`
   - D. `terraform fmt`
   - Correct answer: `A`

13. What does `terraform taint` historically do?
   - A. Deletes the resource from the cloud immediately
   - B. Marks a resource for recreation on the next apply
   - C. Moves a resource to a different module
   - D. Removes a resource from state only
   - Correct answer: `B`

14. Which is true about `terraform.tfstate`?
   - A. It is optional and never needed by Terraform
   - B. It maps configuration to real infrastructure and stores resource metadata
   - C. It only stores provider credentials
   - D. It is the same as `.terraform.lock.hcl`
   - Correct answer: `B`

15. Which command can help visualize Terraform dependencies?
   - A. `terraform graph`
   - B. `terraform providers lock`
   - C. `terraform state mv`
   - D. `terraform login`
   - Correct answer: `A`

16. Which Terraform block is used to configure provider requirements and backend settings?
   - A. `provider`
   - B. `terraform`
   - C. `resource`
   - D. `data`
   - Correct answer: `B`

17. What is the main purpose of `terraform validate`?
   - A. To check syntax and internal consistency of the configuration
   - B. To apply resources in test mode
   - C. To install missing providers
   - D. To compare cloud costs
   - Correct answer: `A`

18. Which command removes Terraform's local working directory data so you can reinitialize cleanly?
   - A. `terraform reset`
   - B. Delete the `.terraform` directory
   - C. `terraform clean`
   - D. `terraform destroy`
   - Correct answer: `B`

19. What is the purpose of `terraform providers`?
   - A. It lists providers required by the configuration and modules
   - B. It upgrades all providers automatically
   - C. It logs into the provider registry
   - D. It removes unused providers from state
   - Correct answer: `A`

20. What does `terraform console` allow you to do?
   - A. Open a cloud provider shell
   - B. Interactively evaluate Terraform expressions
   - C. Edit state directly
   - D. Run `apply` without approval
   - Correct answer: `B`

21. Which is true about data sources?
   - A. They always create new infrastructure
   - B. They only work with local providers
   - C. They read existing information from providers
   - D. They replace outputs
   - Correct answer: `C`

22. What is the purpose of a module in Terraform?
   - A. To encrypt state
   - B. To package and reuse infrastructure configuration
   - C. To replace provider plugins
   - D. To store secrets safely
   - Correct answer: `B`

23. Which file name is automatically loaded as a variable definition file if present?
   - A. `variables.auto`
   - B. `terraform.tfvars`
   - C. `terraform.vars.json.lock`
   - D. `main.tfvars.required`
   - Correct answer: `B`

24. Which argument meta-parameter can be used on resources and modules to create multiple instances from a collection?
   - A. `for_each`
   - B. `backend`
   - C. `provider`
   - D. `source`
   - Correct answer: `A`

25. What is the difference between `count` and `for_each`?
   - A. `count` works with numbers, `for_each` works with maps or sets and tracks by key
   - B. `count` is for modules only, `for_each` is for resources only
   - C. `count` prevents recreation, `for_each` forces recreation
   - D. There is no practical difference
   - Correct answer: `A`

26. Which command shows Terraform outputs after an apply?
   - A. `terraform show`
   - B. `terraform outputs`
   - C. `terraform output`
   - D. `terraform state output`
   - Correct answer: `C`

27. What does `terraform show` display?
   - A. Human-readable state or plan information
   - B. Only provider versions
   - C. Only sensitive variables
   - D. Only backend configuration
   - Correct answer: `A`

28. Which command can move an item in state from one address to another?
   - A. `terraform state rm`
   - B. `terraform state mv`
   - C. `terraform state list`
   - D. `terraform import`
   - Correct answer: `B`

29. Why is `terraform state mv` useful?
   - A. It destroys and recreates resources in the cloud
   - B. It migrates resources between providers automatically
   - C. It updates Terraform's state bindings during refactors without recreating remote objects
   - D. It copies outputs between workspaces
   - Correct answer: `C`

30. What does `terraform state list` do?
   - A. Lists resources tracked in the state
   - B. Lists all files in `.terraform`
   - C. Lists all available providers from the registry
   - D. Lists only tainted resources
   - Correct answer: `A`

31. What is a common use case for `terraform import`?
   - A. To install a provider plugin
   - B. To bring existing infrastructure under Terraform state management
   - C. To copy a module from the public registry
   - D. To merge two state files automatically
   - Correct answer: `B`

32. Which statement about `terraform destroy` is correct?
   - A. It only deletes local state
   - B. It destroys managed infrastructure defined in the current configuration/state
   - C. It removes providers from `.terraform.lock.hcl`
   - D. It only works with local backends
   - Correct answer: `B`

33. Why would you use `terraform plan -out=tfplan`?
   - A. To save a reviewed execution plan for later apply
   - B. To export outputs to JSON
   - C. To back up the state file
   - D. To skip provider initialization
   - Correct answer: `A`

34. What is the benefit of applying a saved plan file?
   - A. Terraform re-checks and changes the plan automatically during apply
   - B. You apply exactly the reviewed plan that was saved
   - C. It bypasses state locking
   - D. It removes the need for variables
   - Correct answer: `B`

35. Which is true about provider version constraints?
   - A. They are only useful in child modules
   - B. They help control which provider versions Terraform can install
   - C. They replace the lock file entirely
   - D. They are stored only in state
   - Correct answer: `B`

36. What is the purpose of `required_providers`?
   - A. To define provider source addresses and version constraints
   - B. To declare module outputs
   - C. To specify resource dependencies
   - D. To pin Terraform CLI version only
   - Correct answer: `A`

37. What does `required_version` do in the `terraform` block?
   - A. Pins the provider version
   - B. Restricts which Terraform CLI versions can be used
   - C. Sets the state schema version
   - D. Forces module upgrades
   - Correct answer: `B`

38. Which statement about child modules is correct?
   - A. Child modules automatically inherit backend settings from the parent as configurable input
   - B. Child modules are called from a `module` block in another configuration
   - C. Child modules can only exist in the public registry
   - D. Child modules cannot contain outputs
   - Correct answer: `B`

39. What is the purpose of `source` inside a module block?
   - A. It tells Terraform where to find the module code
   - B. It tells Terraform which provider alias to use
   - C. It stores module state remotely
   - D. It controls module variable validation
   - Correct answer: `A`

40. Why are outputs useful in child modules?
   - A. They let child modules expose values to the parent module
   - B. They replace variables entirely
   - C. They prevent drift
   - D. They lock state automatically
   - Correct answer: `A`

41. What is a `.tfvars` file used for?
   - A. Defining provider source addresses
   - B. Supplying variable values
   - C. Storing outputs between runs
   - D. Locking Terraform state
   - Correct answer: `B`

42. Which file extension is valid for JSON-based Terraform variable files?
   - A. `.tf.jsonvars`
   - B. `.auto.json`
   - C. `.tfvars.json`
   - D. `.vars.tfjson`
   - Correct answer: `C`

43. Which command can display outputs in a raw string form useful for scripts?
   - A. `terraform output -raw <name>`
   - B. `terraform show -raw <name>`
   - C. `terraform state show -raw <name>`
   - D. `terraform console -raw <name>`
   - Correct answer: `A`

44. What is the purpose of `TF_LOG`?
   - A. To format logs before saving state
   - B. To enable Terraform debug logging
   - C. To configure backend retries
   - D. To set provider region defaults
   - Correct answer: `B`

45. Which Terraform command is best suited for checking canonical file formatting across a configuration?
   - A. `terraform output`
   - B. `terraform fmt -check`
   - C. `terraform validate`
   - D. `terraform graph`
   - Correct answer: `B`

46. Which statement best describes remote state?
   - A. State stored only in `.terraform.lock.hcl`
   - B. State stored in a shared backend such as S3 or HCP Terraform
   - C. State automatically removed after every apply
   - D. State stored only in child modules
   - Correct answer: `B`

47. What is a major benefit of remote state with locking?
   - A. It removes the need for `terraform init`
   - B. It prevents concurrent state modification by multiple users
   - C. It prevents all infrastructure drift automatically
   - D. It eliminates the need for outputs
   - Correct answer: `B`

48. Which backend is commonly used with DynamoDB for state locking in AWS?
   - A. `local`
   - B. `consul`
   - C. `s3`
   - D. `http`
   - Correct answer: `C`

49. What is the purpose of `terraform refresh` historically?
   - A. To upgrade providers
   - B. To sync state with real infrastructure
   - C. To recreate drifted resources
   - D. To format Terraform files
   - Correct answer: `B`

50. Which statement about sensitive values is correct?
   - A. Marking a value sensitive always removes it from state
   - B. Sensitive values are hidden in standard CLI output but may still exist in state
   - C. Sensitive values can only be used in HCP Terraform
   - D. Sensitive values cannot be passed into modules
   - Correct answer: `B`

51. What is the best reason to avoid manually editing Terraform state unless absolutely necessary?
   - A. State files are always encrypted
   - B. Manual state edits can corrupt Terraform's mapping to real infrastructure
   - C. State changes are ignored by `terraform plan`
   - D. Terraform automatically repairs any broken state
   - Correct answer: `B`

52. Which command is useful when you want to see which providers a configuration depends on?
   - A. `terraform providers`
   - B. `terraform show`
   - C. `terraform graph`
   - D. `terraform workspace show`
   - Correct answer: `A`

53. What is one advantage of using HCP Terraform or Terraform Cloud?
   - A. It removes the need for providers
   - B. It offers collaboration features such as remote runs and policy controls
   - C. It forces all modules to be public
   - D. It stores secrets directly in Git
   - Correct answer: `B`

54. What is a policy-as-code feature associated with HCP Terraform?
   - A. `count`
   - B. Sentinel
   - C. `locals`
   - D. `lookup()`
   - Correct answer: `B`

55. Which statement about Terraform workspaces is correct?
   - A. Workspaces are a full replacement for good environment design in all cases
   - B. Workspaces allow multiple state instances for the same configuration
   - C. Workspaces create separate provider plugins for each environment
   - D. Workspaces automatically create separate Git branches
   - Correct answer: `B`

56. Which is a good use case for `terraform.workspace`?
   - A. Dynamically changing behavior or names based on the current workspace
   - B. Replacing all input variables
   - C. Changing backend type after init
   - D. Importing unmanaged infrastructure automatically
   - Correct answer: `A`

57. What is the best next step after finishing a practice exam and scoring it?
   - A. Ignore wrong answers and move straight to the next source
   - B. Memorize only the final score
   - C. Review each wrong answer, identify the reasoning gap, and reinforce it with docs or hands-on practice
   - D. Retake the same 10 easiest questions only
   - Correct answer: `C`
