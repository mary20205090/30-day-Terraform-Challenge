# Day 30 Final Readiness Check

This file records the final readiness questions, my answers, and the final assessment before the Terraform Associate exam.

Use these questions as a cold recall check. If you can answer them without notes, you are likely ready for the exam's conceptual and scenario-based questions.

## Result

- Readiness rating: `Ready`
- Assessment: `9.5 / 10`

## Questions and Answers

1. What does `terraform init` do to your `.terraform` directory?

   It initializes and populates the `.terraform` directory by downloading provider plugins, modules, and setting up backend/configuration metadata needed for the working directory.

2. What is the difference between `terraform.tfstate` and `terraform.tfstate.backup`?

   `terraform.tfstate` is the current live state file used by Terraform. `terraform.tfstate.backup` is the previous state snapshot automatically saved before the most recent state update.

3. Why should you never commit `terraform.tfstate` to version control?

   Because it can contain sensitive data and represents real infrastructure state. Committing it can expose secrets and cause state conflicts or corruption across teams.

4. What does `depends_on` do and when should you use it?

   `depends_on` explicitly defines a dependency when Terraform cannot infer it automatically from references. It should be used for hidden or implicit dependencies, not normal reference-based dependencies.

5. What is the difference between a `variable` block and a `locals` block?

   A `variable` block defines input values passed into a module from outside. A `locals` block defines internal computed values used only within the module and cannot be set from outside.

6. What happens if you run `terraform apply` and the state file has been modified by another team member since your last `terraform plan`?

   If applying a saved plan and state changed after the plan was created, Terraform rejects the saved plan as stale. If running a normal `terraform apply`, Terraform refreshes state, creates a new plan, and uses state locking if the backend supports it.

7. What does the `terraform graph` command output and what is it used for?

   It outputs a dependency graph in DOT format. It is used for visualizing infrastructure dependencies and debugging resource ordering.

8. What is the Terraform Registry and what are the three types of things published there?

   The Terraform Registry is a public repository for reusable Terraform components. It publishes providers, modules, and policy libraries.

9. What is the difference between Terraform Cloud and Terraform Enterprise?

   Terraform Cloud is the SaaS version managed by HashiCorp. Terraform Enterprise is the self-hosted version for private environments with more control, compliance, and network isolation.

10. When a module uses `configuration_aliases`, what problem does it solve?

    It allows a child module to declare that it expects aliased provider configurations from the parent module, such as multiple regions or accounts.

## Final Notes

The only answer that needed sharpening was question 6 around stale saved plans.

Exam-precise version:

- A saved plan is tied to the state snapshot used when it was created.
- If state changes before that saved plan is applied, Terraform rejects it as stale.
- A normal `terraform apply` refreshes state, creates a new plan, and then asks for approval.
- State locking prevents concurrent state-changing operations when the backend supports locking.

The final exam readiness assessment is still `Ready` because the distinction is now clear.
