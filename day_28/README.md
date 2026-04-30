# Day 28: Exam Preparation - Practice Exams 1 & 2

Day 28 is focused on full exam simulation under timed conditions.

The goal is not casual review. The goal is to:

- simulate real Terraform Associate exam pressure
- score accurately
- identify weak domains
- review wrong answers properly before exam day

## References

- Official sample questions:
  - https://learn.hashicorp.com/tutorials/terraform/associate-questions
- Terraform Associate review tutorial:
  - https://developer.hashicorp.com/terraform/tutorials/certification-004/associate-review-004
- Extra practice source:
  - https://www.examtopics.com/exams/hashicorp/terraform-associate-004/

## Practice Exam 1

- Questions attempted: `57`
- Correct: `54`
- Score: `94.7%`
- Result: `Pass`
- Sources used:
  - HashiCorp sample questions
  - HashiCorp review topics
  - additional practice-style questions aligned to the Associate 004 domains
- Full question set:
  - [practice_exam_1.md](./practice_exam_1.md)

### Questions Missed

#### Question 4

- Question: What is an advantage of immutable infrastructure?
- Topic: Immutable infrastructure
- My answer: Incorrect
- Correct answer: `D`
- Why I was wrong: I need to distinguish immutable infrastructure from in-place upgrades. The key idea is replacing existing infrastructure with a fresh version instead of modifying running resources directly.
- Reinforcement: Immutable infrastructure reduces the complexity and risk that come with changing long-running systems in place.

#### Question 6

- Question: Your team adopts AWS CloudFormation as the standardized method for provisioning public cloud resources. Which scenario presents a challenge for your team?
- Topic: Terraform purpose vs cloud-specific tooling
- My answer: `B`
- Correct answer: `A`
- Why I was wrong: I focused on automation instead of vendor scope. CloudFormation is AWS-specific, so the real challenge is deploying the same approach into Azure.
- Reinforcement: Terraform is provider-agnostic, CloudFormation is not.

#### Question 15

- Question: You have two AWS provider configurations, one default and one aliased as `west`. How do you tell a resource to use the aliased provider?
- Topic: Provider aliases
- My answer: `D`
- Correct answer: `C`
- Why I was wrong: I confused alias declaration with alias usage. `alias = "west"` is defined in the provider block, but resources use the alias with `provider = aws.west`.
- Hands-on fix:

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_s3_bucket" "west_bucket" {
  provider = aws.west
  bucket   = "example-west-bucket-12345"
}
```

## Domain Notes From Exam 1

Strong areas:

- Terraform CLI
- State management
- Modules
- Core workflow
- HCP Terraform / Terraform Cloud
- Configuration and functions

Light review needed:

- IaC concepts
- Terraform purpose
- Provider alias syntax

## Practice Exam 2

- Questions attempted: `57`
- Correct: `56`
- Score: `98.2%`
- Result: `Pass`
- Sources used:
  - practice-style questions aligned to Terraform Associate 004 domains
- Full question set:
  - [practice_exam_2.md](./practice_exam_2.md)

### Questions Missed

#### Question 28

- Question: Which command can move an item in state from one address to another?
- Topic: State management
- My answer: `D`
- Correct answer: `B`
- Why I was wrong: I mixed up importing unmanaged infrastructure with refactoring existing state bindings. `terraform import` brings an existing object into state, while `terraform state mv` changes where an already tracked object lives in state.
- Reinforcement: `state mv` is especially useful during refactors, such as moving a resource into a module without recreating it.

### Domain Notes From Exam 2

Strong areas:

- Terraform fundamentals
- CLI and workflow
- Modules and configuration
- Remote state
- HCP Terraform / Terraform Cloud

Light review needed:

- State subcommands, especially `state mv`

## Score Comparison

- Exam 1: `54/57` (`94.7%`)
- Exam 2: `56/57` (`98.2%`)

Exam 2 was slightly stronger, which suggests the warm-up effect helped rather than fatigue setting in.
