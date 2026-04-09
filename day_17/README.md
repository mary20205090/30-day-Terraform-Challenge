# Day 17: Manual Testing of Terraform Code

Day 17 starts Chapter 9 and shifts the focus from writing infrastructure to
proving that it behaves correctly.

The main lesson of this chapter is simple:

- automated tests are powerful
- but good automated tests usually begin with good manual tests

That is because before you can automate a check, you need to understand:

- what should be tested
- what "correct" behavior looks like
- what can go wrong
- how to verify success and failure safely

This chapter is teaching the first layer of testing discipline.

## What Chapter 9 Is Really About

The book argues that manual testing is not a beginner-only step that you
"graduate past."

Instead, manual testing is the place where you:

- learn the behavior of your infrastructure
- discover what outputs and checks actually matter
- define what your future automated tests should assert

In other words:

- manual testing helps you understand the system
- automated testing helps you repeat that understanding reliably

That is a very important distinction.

## 1. Manual Tests

A manual test means:

- apply the infrastructure
- inspect the resulting resources and behavior
- verify expected outcomes by hand
- destroy everything afterward

This is slower than automated testing, but it teaches you things automation
often hides.

For example, manual testing helps you notice:

- confusing outputs
- slow startup behavior
- bad defaults
- awkward naming
- hidden dependencies
- weak documentation
- messy cleanup steps

Those are all useful findings.

## 2. Why Manual Testing Comes Before Automated Testing

The chapter's reasoning is:

- you cannot automate a check you do not understand

If you do not yet know:

- which outputs matter
- which URLs to hit
- how long the system takes to become healthy
- which resources are expensive
- what "failure" looks like

then your automated tests will likely be:

- shallow
- flaky
- misleading

This connects directly to what happened on Day 16:

- manual apply showed the app worked
- Terratest then helped automate that understanding
- the test only became reliable after we learned:
  - the ALB needed time
  - the instance type was not supported in one AZ
  - the HTTP validation had to match the real HTML response

That is a perfect example of Chapter 9's point.

## 3. Manual Testing Basics

The chapter encourages a more structured manual test process.

Manual testing should answer questions like:

### Did Terraform succeed technically?

Check:

- did `terraform init` succeed?
- did `terraform validate` succeed?
- did `terraform plan` show the expected resources?
- did `terraform apply` complete successfully?

This verifies that the configuration is syntactically and operationally valid.

### Did the infrastructure get created correctly?

Check:

- are the expected AWS resources present?
- do the names and tags look correct?
- are outputs populated?

This is the "resource existence" layer of testing.

### Does the system behave correctly?

Check:

- can the app be reached?
- does the ALB return the expected page?
- are health checks passing?
- are alarms and supporting resources created?

This is the "functional behavior" layer of testing.

### Does the infrastructure match your intent?

Check:

- are security groups tighter than before?
- are only the right ports exposed?
- are module inputs doing what you expected?
- are safer lifecycle rules behaving correctly?

This matters because infrastructure can be "working" while still being badly
designed.

### Can you clean it up safely?

Check:

- does `terraform destroy` work?
- is there any leftover infrastructure?
- do you understand destroy ordering?

This is especially important in AWS because bad cleanup discipline quickly
turns into unnecessary cost.

## 4. What Manual Tests Catch That Automated Tests Sometimes Miss

This is one of the most useful parts of the chapter.

Manual tests can reveal:

- poor UX in module inputs and outputs
- confusing naming
- long startup delays
- operational awkwardness
- missing documentation
- cleanup surprises
- cloud-provider quirks

Automated tests are better at:

- repeatability
- regression detection
- consistency

But manual tests are often better at:

- understanding
- observation
- noticing bad design
- discovering what should be automated next

So manual testing is not inferior.

It is a different kind of test with a different purpose.

## 5. Cleaning Up After Tests

The chapter strongly emphasizes cleanup.

This is not just a cost note.

It is part of testing discipline.

A good manual test should always include:

- how to destroy the infrastructure
- how to confirm the destroy worked
- how to detect leftovers

Why this matters:

- AWS resources cost money
- leftover load balancers, EC2, RDS, EKS, and EIPs can keep billing
- manual tests become risky if cleanup is unreliable

For your challenge, this is especially relevant because you have been careful
about:

- destroying resources after each lesson
- avoiding unnecessary credit usage
- using local state or lightweight backends where helpful

That is already a strong testing habit.

## 6. What a Good Manual Test Should Include

A good manual test plan should document:

- the folder being tested
- the exact commands to run
- what successful outputs should look like
- what URL or endpoint should respond
- what AWS resources should exist
- how long readiness may take
- the cleanup command
- how to confirm cleanup

This turns ad-hoc testing into a repeatable process.

That is exactly the bridge between manual and automated testing.

## 7. Day 17 Mindset Shift

Before this chapter, the easy assumption is:

- testing means writing automated tests

After this chapter, the better view is:

- manual testing teaches you what should be automated

That makes manual testing the foundation rather than the fallback.

## 8. How Day 16 Carries Forward Into Day 17

Day 16 gave you:

- smaller reusable modules
- example root module testing
- clearer outputs
- better tagging
- better validation
- Terratest experience

Day 17 builds on that by asking:

- what exact manual checks should be documented for these modules?
- what counts as success?
- what counts as failure?
- what cleanup steps are mandatory?

So Day 17 is not separate from Day 16.

It is the next layer of maturity.

## 9. The Most Important Takeaways

If you remember only these, you are in a strong place:

1. Manual testing is a necessary precursor to automated testing.
2. Good manual tests verify both resource creation and real behavior.
3. Cleanup is part of the test, not an optional afterthought.
4. Manual testing teaches you what your future automated tests should assert.
5. Cloud cost awareness is part of good testing discipline.

## 10. What We Should Do Next for the Day 17 Lab

The next practical step should be:

1. choose one existing piece of infrastructure to test manually
2. define the exact commands to run
3. define what success looks like
4. define how to verify outputs and behavior
5. define the cleanup steps
6. document findings and gaps

That will turn today's reading into a real Day 17 manual test workflow.

## Day 17 Lab Structure

Day 17 keeps the Day 16 production-grade module pattern, but gives manual
testing its own isolated environments:

- `day_17/modules`
  - reusable ALB, ASG, and service modules
- `day_17/environments/dev`
  - lower-cost manual test target
- `day_17/environments/production`
  - production-flavored manual test target
- `day_17/docs/manual-test-checklist.md`
  - the checklist to run in both environments
- `day_17/docs/test-results-template.md`
  - a compact template for documenting pass/fail findings

## Recommended Day 17 Run Order

Start in dev first:

```bash
cd day_17/environments/dev
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform plan
```

Then run the functional checks:

- open the ALB DNS name in a browser
- `curl http://<alb-dns>`
- confirm the ASG and target group are healthy
- stop one instance manually and confirm the ASG replaces it

Then test cleanup:

```bash
terraform plan -destroy
terraform destroy
```

After destroy, verify leftovers with:

```bash
aws ec2 describe-instances --filters "Name=tag:ManagedBy,Values=terraform" --query "Reservations[*].Instances[*].InstanceId"
aws elbv2 describe-load-balancers --query "LoadBalancers[*].LoadBalancerArn"
```

Repeat the same flow in:

- `day_17/environments/production`

## Why Two Environments Matter

Day 17 is not just about proving the configuration works once.

It is about checking whether behavior changes unexpectedly between:

- dev
- production

That is how manual testing starts to reveal:

- environment-specific differences
- scaling assumptions
- unsupported instance/AZ combinations
- cleanup issues
