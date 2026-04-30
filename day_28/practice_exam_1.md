# Practice Exam 1

This file contains the full 57-question set used for Day 28 Practice Exam 1, along with the correct answers.

## Questions 1-57

1. IaC (Infrastructure as Code) can be stored in a version control system along with application code.
   - A. True
   - B. False
   - Correct answer: `A`

2. It is best practice to store secret data in the same version control repository as your Terraform configuration.
   - A. True
   - B. False
   - Correct answer: `B`

3. Which is an advantage of using IaC (Infrastructure as Code) that is not possible when provisioning with a GUI (Graphical User Interface)?
   - A. Lets you version, reuse, and share infrastructure configuration.
   - B. Secures your credentials.
   - C. Provisions the same resources at a lower cost.
   - D. Prevents manual modifications to your resources.
   - Correct answer: `A`

4. What is an advantage of immutable infrastructure?
   - A. Automatic infrastructure upgrades
   - B. In-place infrastructure upgrades
   - C. Quicker infrastructure upgrades
   - D. Less complex infrastructure upgrades
   - Correct answer: `D`

5. What is the primary purpose of IaC (Infrastructure as Code)?
   - A. To define a pipeline to test and deliver software.
   - B. To provision infrastructure cheaply.
   - C. To programmatically create and configure resources.
   - D. To define a vendor-agnostic API.
   - Correct answer: `C`

6. Your team adopts AWS CloudFormation as the standardized method for provisioning public cloud resources. Which scenario presents a challenge for your team?
   - A. Deploying new infrastructure into Microsoft Azure.
   - B. Automating a manual, web console-based provisioning process.
   - C. Building a reusable code base that can deploy resources into any AWS region.
   - D. Managing a new application stack built on AWS-native services.
   - Correct answer: `A`

7. Which is not a benefit of adopting IaC (Infrastructure as Code)?
   - A. Reusability of code
   - B. Automation
   - C. A GUI (Graphical User Interface)
   - D. Versioning
   - Correct answer: `C`

8. How does the use of Infrastructure as Code (IaC) enhance the reliability of your infrastructure? (Choose two.)
   - A. Configuration drift is reduced with declarative definitions.
   - B. Updates are deployed with zero downtime.
   - C. Proposed changes can be reviewed before being applied.
   - D. Incorrect configurations cannot be deployed.
   - E. Infrastructure is automatically scaled to meet demand.
   - Correct answer: `A, C`

9. Your team often uses API calls to create and manage cloud infrastructure. In what ways does Terraform differ from conventional infrastructure management approaches?
   - A. Terraform replaces cloud provider APIs with its own protocols, enabling automated deployments.
   - B. Terraform describes infrastructure with version-controlled, repeatable configurations that specify the desired state.
   - C. Terraform is merely a wrapper for cloud provider APIs, so there is little to no difference in calling the API directly.
   - D. Terraform enforces infrastructure through imperative scripts to ensure tasks are completed in the proper order.
   - Correct answer: `B`

10. Which of these workflows is only enabled by the use of Infrastructure as Code?
   - A. Automatic scaling of resources based on application load.
   - B. Cost optimization of infrastructure deployment.
   - C. Role-based access control of cloud resources.
   - D. Reviewing the proposed changes for potential security issues.
   - Correct answer: `D`

11. What does Terraform use to deploy infrastructure for different cloud providers?
   - A. Custom APIs developed by HashiCorp
   - B. Vendors' CLI tools
   - C. Vendors' UI
   - D. Vendor-specific providers
   - Correct answer: `D`

12. How can you enable verbose logging to troubleshoot?
   - A. Set the log level command line flag.
   - B. Set the TF_LOG environment variable.
   - C. Set the log level in your terraform block.
   - Correct answer: `B`

13. Which file records the provider versions and checksums Terraform has selected for a configuration?
   - A. `terraform.tfstate`
   - B. `.terraform.lock.hcl`
   - C. `terraform.tfvars`
   - D. `.terraform/providers.lock`
   - Correct answer: `B`

14. What does `terraform init -upgrade` do?
   - A. Destroys and recreates the backend
   - B. Upgrades providers and modules to newer allowed versions
   - C. Rewrites all Terraform files to the newest syntax
   - D. Applies the latest saved plan automatically
   - Correct answer: `B`

15. You have two AWS provider configurations, one default and one aliased as `west`. How do you tell a resource to use the aliased provider?
   - A. `region = "west"`
   - B. `provider = "aws.west"`
   - C. `provider = aws.west`
   - D. `alias = "west"`
   - Correct answer: `C`

16. What is the main purpose of `terraform validate`?
   - A. To check formatting
   - B. To check syntax and internal consistency
   - C. To apply changes in dry-run mode
   - D. To compare state with real infrastructure
   - Correct answer: `B`

17. What is the best description of `terraform plan -target=...`?
   - A. It permanently limits future applies to the targeted resource
   - B. It plans only a subset of resources, usually for exceptional troubleshooting
   - C. It upgrades targeted providers only
   - D. It skips the state refresh step
   - Correct answer: `B`

18. What does `terraform apply -auto-approve` do?
   - A. Skips plugin installation
   - B. Skips the interactive approval prompt
   - C. Skips state updates
   - D. Skips backend initialization
   - Correct answer: `B`

19. Which command is equivalent in intent to destroying managed infrastructure?
   - A. `terraform apply -replace`
   - B. `terraform plan -destroy`
   - C. `terraform destroy`
   - D. `terraform state rm`
   - Correct answer: `C`

20. What does `terraform output -json` return?
   - A. Only sensitive outputs
   - B. Outputs in machine-readable JSON
   - C. Outputs from all workspaces at once
   - D. Raw provider responses
   - Correct answer: `B`

21. What happens when you run `terraform state rm aws_instance.web`?
   - A. The EC2 instance is deleted in AWS
   - B. The EC2 instance is tainted for recreation
   - C. The EC2 instance remains in AWS, but Terraform forgets it
   - D. The EC2 instance is moved to another workspace
   - Correct answer: `C`

22. What does `terraform import` do?
   - A. Imports existing infrastructure into state
   - B. Imports an external module into the registry
   - C. Generates full `.tf` configuration automatically
   - D. Copies remote state into local state only
   - Correct answer: `A`

23. What happens when you run `terraform workspace new staging`?
   - A. Creates a new directory named `staging`
   - B. Creates a workspace and switches to it
   - C. Renames the current workspace to `staging`
   - D. Creates a new backend bucket
   - Correct answer: `B`

24. With the local backend, where is Terraform state stored by default?
   - A. In AWS S3
   - B. In HCP Terraform
   - C. In a local `terraform.tfstate` file
   - D. In `.terraform.lock.hcl`
   - Correct answer: `C`

25. What is the main purpose of state locking?
   - A. To encrypt the state file
   - B. To prevent concurrent state modifications
   - C. To reduce plan time
   - D. To validate provider versions
   - Correct answer: `B`

26. A teammate manually deletes a Terraform-managed bucket in the cloud console. What will `terraform plan` usually show next?
   - A. No changes, because Terraform trusts the state file completely
   - B. The bucket will be recreated to match configuration
   - C. Terraform will fail permanently until state is deleted
   - D. Terraform will automatically remove the bucket from state
   - Correct answer: `B`

27. What does `terraform apply -refresh-only` do?
   - A. Updates remote infrastructure only
   - B. Updates state and outputs to reflect real infrastructure without changing resources
   - C. Forces recreation of drifted resources
   - D. Only refreshes provider plugins
   - Correct answer: `B`

28. Which Terraform block type is used to query existing infrastructure instead of creating it?
   - A. `output`
   - B. `resource`
   - C. `data`
   - D. `locals`
   - Correct answer: `C`

29. Which block type creates or manages infrastructure objects?
   - A. `resource`
   - B. `data`
   - C. `terraform`
   - D. `variable`
   - Correct answer: `A`

30. Which construct is best for reusing computed values inside the same module?
   - A. outputs
   - B. providers
   - C. locals
   - D. backends
   - Correct answer: `C`

31. What is the main purpose of an `output` block?
   - A. To create hidden variables
   - B. To expose values from a module or root configuration
   - C. To define dependencies explicitly
   - D. To import existing resources
   - Correct answer: `B`

32. Which function is best when you want to safely retrieve a value from a map and provide a fallback default?
   - A. `merge()`
   - B. `lookup()`
   - C. `length()`
   - D. `file()`
   - Correct answer: `B`

33. Which function reads the contents of a local file?
   - A. `templatefile()`
   - B. `lookup()`
   - C. `file()`
   - D. `tolist()`
   - Correct answer: `C`

34. What is a key advantage of `for_each` over `count` when items are removed from the middle of a collection?
   - A. `for_each` always creates resources faster
   - B. `for_each` preserves resources by key, reducing index shifting problems
   - C. `for_each` cannot use maps
   - D. `for_each` automatically prevents drift
   - Correct answer: `B`

35. When should you use `depends_on`?
   - A. For every resource, by default
   - B. Only when Terraform cannot infer a dependency you need
   - C. Only for providers
   - D. Only with modules from the public registry
   - Correct answer: `B`

36. What does `sensitive = true` do for a variable or output?
   - A. Prevents the value from being written to state
   - B. Encrypts the value automatically in state
   - C. Masks the value in normal CLI output, but it may still exist in state
   - D. Prevents the value from being passed to providers
   - Correct answer: `C`

37. What is the better practice for handling secrets in Terraform?
   - A. Commit them to Git if the repo is private
   - B. Hardcode them in `locals`
   - C. Use a secrets manager or secure variable mechanism
   - D. Put them only in comments so Terraform ignores them
   - Correct answer: `C`

38. Can a `backend` block use normal input variables like `var.bucket_name`?
   - A. Yes
   - B. No
   - C. Only in HCP Terraform
   - D. Only with the local backend
   - Correct answer: `B`

39. Which module source pin is immutable and safer for repeatable builds?
   - A. `?ref=main`
   - B. `?ref=latest`
   - C. `?ref=v1.0.0`
   - D. `?ref=HEAD`
   - Correct answer: `C`

40. Which statement about module variable scope is correct?
   - A. Child modules automatically inherit all parent variables
   - B. Child modules only receive values explicitly passed to them
   - C. Variables can only be used in the root module
   - D. Module variables must always have defaults
   - Correct answer: `B`

41. The `version` argument inside a `module` block is used primarily with:
   - A. Local path modules
   - B. Registry modules
   - C. Any Git source
   - D. Data sources
   - Correct answer: `B`

42. What does `terraform.workspace` return?
   - A. The backend type
   - B. The current Terraform CLI workspace name
   - C. The HCP Terraform organization name
   - D. The current provider alias
   - Correct answer: `B`

43. In HCP Terraform, what is a workspace?
   - A. A local folder on disk
   - B. A state and run context for a set of Terraform operations
   - C. A replacement for modules
   - D. A provider plugin cache
   - Correct answer: `B`

44. What is the purpose of `terraform login`?
   - A. Authenticate the CLI with HCP Terraform/Terraform Cloud
   - B. Authenticate AWS providers
   - C. Log into the Terraform Registry website
   - D. Unlock a remote state file
   - Correct answer: `A`

45. What is the main purpose of a private module registry?
   - A. To replace backends
   - B. To share versioned modules internally
   - C. To store state files
   - D. To run plans remotely
   - Correct answer: `B`

46. What are remote operations in HCP Terraform?
   - A. Terraform runs only on your laptop but stores logs remotely
   - B. Plans and applies run in HCP Terraform instead of locally
   - C. Providers are downloaded from remote Git repositories only
   - D. State is disabled and replaced by variables
   - Correct answer: `B`

47. What is the purpose of variable sets in HCP Terraform?
   - A. To replace all workspace variables permanently
   - B. To share common variables across multiple workspaces
   - C. To define output values
   - D. To store provider binaries
   - Correct answer: `B`

48. Which of the following is a governance/collaboration feature of HCP Terraform?
   - A. Provider aliasing
   - B. Policy enforcement
   - C. `terraform fmt`
   - D. `count`
   - Correct answer: `B`

49. Which TWO Terraform commands are primarily used to inspect state?
   - A. `terraform state list`
   - B. `terraform state show`
   - C. `terraform state rm`
   - D. `terraform import`
   - Correct answer: `A, B`

50. Which TWO commands can change Terraform's state bindings without destroying remote resources?
   - A. `terraform state mv`
   - B. `terraform state rm`
   - C. `terraform destroy`
   - D. `terraform output`
   - Correct answer: `A, B`

51. What is configuration drift?
   - A. When providers are outdated
   - B. When the backend bucket changes region
   - C. When real infrastructure no longer matches the declared or tracked state
   - D. When a module source is pinned to a tag
   - Correct answer: `C`

52. Which command formats Terraform files recursively?
   - A. `terraform validate -recursive`
   - B. `terraform fmt -recursive`
   - C. `terraform plan -recursive`
   - D. `terraform output -recursive`
   - Correct answer: `B`

53. What does `terraform graph` produce?
   - A. A cost estimate
   - B. A dependency graph
   - C. A JSON state snapshot
   - D. A list of all providers in use
   - Correct answer: `B`

54. What is the main purpose of a provider block?
   - A. To declare resource dependencies
   - B. To configure access/settings for a provider
   - C. To store module outputs
   - D. To define backend locking
   - Correct answer: `B`

55. Which TWO are common benefits of using remote state?
   - A. Easier collaboration
   - B. Built-in state locking support with supported backends
   - C. Automatic zero-downtime deployments
   - D. Elimination of provider credentials
   - Correct answer: `A, B`

56. Which statement best describes declarative Infrastructure as Code?
   - A. You define the exact sequence of shell commands to run
   - B. You define the desired end state and Terraform works toward it
   - C. You must specify every API request manually
   - D. It only works in a single cloud
   - Correct answer: `B`

57. Which scenario best matches immutable infrastructure?
   - A. Logging into a running server and patching it in place
   - B. Editing a database manually in production
   - C. Replacing an old instance with a newly built one instead of modifying it
   - D. Updating security groups one rule at a time through the console
   - Correct answer: `C`
