# Day 10: Terraform Loops and Conditionals

Day 10 focuses on making Terraform configurations more dynamic and less repetitive.

In this folder, I explored:

- `count` for creating multiple similar resources
- `for_each` for creating resources from sets and maps
- `for` expressions for transforming Terraform data
- ternary conditionals for optional resources and environment-specific behavior

## Files

- `main.tf` - Day 10 standalone demos for `count`, `for_each`, and conditionals
- `variables.tf` - input variables and sample IAM user data
- `outputs.tf` - outputs showing `for` expression results

## What I Practiced

- creating IAM users with `count`
- seeing why `count` is fragile when list order changes
- creating IAM users with `for_each`
- using maps to attach extra per-user configuration
- outputting transformed data with `for` expressions
- changing EC2 instance type with a conditional and `locals`

## Key Lesson

The biggest takeaway from Day 10 is:

- `count` is simple, but index-based
- `for_each` is safer when collections can change
- `for` expressions reshape data cleanly
- conditionals make Terraform logic flexible without duplicating code
