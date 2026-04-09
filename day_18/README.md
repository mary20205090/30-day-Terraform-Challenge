# Day 18: Automated Testing of Terraform Code

Day 18 completes Chapter 9 and moves from:

- testing infrastructure by hand

to:

- testing infrastructure automatically and repeatedly

The main idea of this chapter is that manual testing teaches you what matters,
but automated testing is what lets a team keep that confidence on every change.

This is the day where Terraform testing becomes something that can scale.

## What Chapter 9 Is Really About

The chapter argues that manual testing is necessary, but it eventually becomes
too slow and too fragile on its own.

If your infrastructure grows to the point where:

- multiple engineers are changing it
- changes happen frequently
- environments are more complex
- regressions are expensive

then relying on manual checks alone becomes risky.

That is where automated tests help.

Automated tests give you:

- repeatability
- fast feedback
- regression protection
- team confidence
- easier CI/CD integration

So the chapter's overall message is:

- manual testing helps you understand the system
- automated testing helps you protect that understanding over time

## 1. Automated Tests

The chapter introduces three major layers of automated testing:

- unit tests
- integration tests
- end-to-end tests

Each layer answers a different question.

This is important because many people say "testing" as if it is one thing.

It is not.

Good testing uses multiple layers, each with a different purpose, cost, and
speed.

## 2. Unit Tests

Unit tests are the smallest and fastest tests.

A unit test checks a narrow piece of logic in isolation.

In Terraform terms, a unit test usually focuses on:

- rendered outputs
- variable validation
- input/output logic
- template rendering
- naming logic
- tag composition
- policy or helper logic

without needing to fully provision real cloud infrastructure.

### Plain-English meaning

A unit test asks:

- does this small piece of configuration logic behave as expected?

Examples for your Terraform work:

- does `common_tags` include the expected keys?
- does the environment validation reject invalid values?
- does the rendered user data include the right app text and port?
- does a module output the name or DNS value you expect?

### Why unit tests matter

They are:

- cheap
- quick
- easy to run often

But they do not prove the real cloud infrastructure actually works.

That is their limitation.

## 3. Integration Tests

Integration tests check whether multiple pieces work together correctly.

In Terraform, that often means:

- run Terraform against a real example root module
- create real infrastructure
- verify that modules interact correctly

This is exactly the kind of testing you touched on in Day 16 with Terratest.

### Plain-English meaning

An integration test asks:

- when these modules are composed together, do they behave correctly?

Examples for your webserver infrastructure:

- does the ALB connect to the target group?
- does the ASG launch instances correctly?
- do the security groups allow the ALB to reach the app?
- does the output expose the ALB DNS name properly?

### Why integration tests matter

They verify more than unit tests because they exercise:

- real provider behavior
- resource dependencies
- module composition
- real cloud responses

But they are slower and costlier than unit tests.

## 4. End-to-End Tests

End-to-end tests are the broadest and most realistic tests.

They check the full system from the outside, the way a user or downstream
system experiences it.

### Plain-English meaning

An end-to-end test asks:

- can the fully deployed system do what it is supposed to do from end to end?

Examples for your webserver cluster:

- can a user reach the ALB?
- does the browser show the expected page?
- does `curl` return the expected response?
- if one instance is stopped, does the ASG replace it and keep the app
  available?

### Why end-to-end tests matter

They catch things unit and integration tests may miss, such as:

- DNS behavior
- load balancer routing
- startup timing
- real user-facing responses
- real environment interaction

But they are the slowest and most expensive tests.

## 5. Mapping the Test Layers to Your Infrastructure

This chapter becomes much easier when you map each test type to something you
already built.

For your Day 16 and Day 17 webserver setup:

### What a unit test could look like

- validate `environment` only allows `dev`, `staging`, `production`
- validate `instance_type` only allows expected families
- check rendered user data contains `Hello from Day 17 Dev` or the chosen port
- check naming/tag locals produce the expected values

These tests focus on Terraform logic, not real AWS behavior.

### What an integration test could assert

- the example root module applies successfully
- ALB, target group, ASG, and alarms are created together
- outputs such as `alb_dns_name` are returned
- the module composition works correctly

This is close to the Terratest pattern you already used.

### What an end-to-end test could verify

- the ALB URL returns the expected page
- the app stays reachable after an instance replacement
- cleanup removes all active resources after the test

This is the closest thing to a user-level verification.

## 6. Why You Need All Three Layers

No single test layer is enough.

### Unit tests alone are not enough

Because they cannot tell you:

- whether AWS actually accepts the config
- whether resources connect correctly
- whether the app is reachable

### Integration tests alone are not enough

Because they may still miss:

- the real user-facing behavior
- the final network path
- actual end-to-end availability

### End-to-end tests alone are not enough

Because they are:

- expensive
- slow
- harder to debug when they fail

So the best testing strategy is layered:

- use unit tests for fast logic checks
- use integration tests for real module composition
- use end-to-end tests for user-visible confidence

## 7. Other Testing Approaches

The chapter also broadens the idea of what "testing" can mean.

Testing is not only:

- apply and check

It can also include:

- static analysis
- linting
- policy checks
- security scanning
- code review
- validation in CI/CD

This matters because strong Terraform quality usually comes from combining:

- several test types
- not betting everything on one test style

## 8. CI/CD and Why It Matters Here

The chapter's automation story naturally leads to CI/CD.

Once you know:

- what to test
- how to test it
- how to judge pass/fail

the next step is:

- run those tests automatically on every commit or pull request

That gives you:

- faster feedback
- fewer regressions
- less fear when refactoring
- shared confidence across the team

For your challenge, this means Day 18 is not just about writing tests.

It is also about preparing a workflow where tests can run automatically in a
pipeline.

## 9. How Day 17 Carries Into Day 18

Day 17 taught:

- what to test manually
- what success looks like
- how to verify cleanup
- how to compare environments

Day 18 builds on that by asking:

- which of those checks should now become automated?
- which ones are best as unit tests?
- which ones are best as integration tests?
- which ones are best as end-to-end checks?

So Day 17 gave you the test ideas.

Day 18 turns those ideas into an automated testing strategy.

## 10. The Most Important Takeaways

If you remember only these, you are in a strong position:

1. Manual testing helps define what matters.
2. Unit tests check small logic quickly.
3. Integration tests verify real module composition.
4. End-to-end tests verify real user-visible behavior.
5. Good infrastructure quality comes from layering these tests.
6. CI/CD makes those tests scalable for a team.

## 11. What We Should Do Next for the Day 18 Lab

The next practical step should be:

1. choose one Day 18 infrastructure target to test automatically
2. define:
   - one unit-style check
   - one integration-style check
   - one end-to-end-style check
3. add a CI workflow that runs the tests automatically

That will turn Chapter 9 from theory into a real Day 18 testing pipeline.

## 12. Day 18 Lab Layout

Today’s code is organized like this:

- `modules/services/webserver-cluster`
  Main Day 18 service module under test.
  Files:
  - `main.tf`
  - `variables.tf`
  - `outputs.tf`
  - `webserver_cluster_test.tftest.hcl`
- `examples/webserver-cluster`
  Lightweight integration harness that reuses the default VPC.
- `modules/networking/vpc`
  Fresh VPC module used by the end-to-end stack.
- `examples/full-stack`
  End-to-end harness that creates its own VPC and then deploys the app.
- `test/webserver_cluster_integration_test.go`
  Go integration test for the lightweight harness.
- `test/full_stack_e2e_test.go`
  Go end-to-end test for the full-stack harness.
- `.github/workflows/terraform-tests.yml`
  CI workflow for all three layers.

## 13. Recommended Run Order

Start with the fastest and cheapest layer first:

1. Unit tests
   `terraform -chdir=day_18/modules/services/webserver-cluster test`
2. Compile the Go tests without creating AWS resources
   `cd day_18/test && go test -run '^$' ./...`
3. Integration test when you are ready to spend a little time and money
   `cd day_18/test && go test -v -timeout 30m -run TestWebserverClusterIntegration ./...`
4. End-to-end test only when you intentionally want the full-stack run
   `cd day_18/test && go test -v -timeout 45m -run TestFullStackEndToEnd ./...`

The key discipline from Day 17 still applies:

- run the smallest test first
- understand what each layer is proving
- confirm cleanup after any AWS-backed test

## 14. What Each Command Means

`terraform -chdir=day_18/modules/services/webserver-cluster test`

- `terraform`
  runs the Terraform CLI
- `-chdir=...`
  tells Terraform to behave as if you first changed into that folder
- `test`
  runs the native `.tftest.hcl` tests in that module

This command targets:

- `day_18/modules/services/webserver-cluster/webserver_cluster_test.tftest.hcl`

That unit test file checks:

- ASG name prefix
- launch template instance type
- instance ingress port
- invalid environment rejection

`go test -run '^$' ./...`

- compiles the Go Terratest files
- runs no real tests
- useful as a quick syntax check before AWS-backed runs

This command targets:

- `day_18/test/webserver_cluster_integration_test.go`
- `day_18/test/full_stack_e2e_test.go`

`go test -v -timeout 30m -run TestWebserverClusterIntegration ./...`

- runs only the integration test
- deploys the lightweight example in `examples/webserver-cluster`
- checks the app returns `Hello from Day 18 Integration`
- destroys the resources afterward

`go test -v -timeout 45m -run TestFullStackEndToEnd ./...`

- runs only the end-to-end test
- deploys the VPC module and then the app module
- checks the app returns `Hello from Day 18 End-to-End`
- destroys the full stack afterward

## 15. What We Verified Today

Unit test:
- file: `day_18/modules/services/webserver-cluster/webserver_cluster_test.tftest.hcl`
- result: passed

Integration test:
- file: `day_18/test/webserver_cluster_integration_test.go`
- root module used: `day_18/examples/webserver-cluster`
- result: passed

End-to-end test:
- file: `day_18/test/full_stack_e2e_test.go`
- root modules used:
  - `day_18/examples/full-stack`
  - `day_18/modules/networking/vpc`
  - `day_18/modules/services/webserver-cluster`
- first result: failed because the subnet CIDRs were outside the VPC CIDR
- fix: align the VPC CIDR and subnet CIDRs inside the test inputs
