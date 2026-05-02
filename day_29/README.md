# Day 29: Exam Preparation - Practice Exams 3 & 4

Day 29 continues the final Terraform Associate exam preparation sprint with two more full practice exams.

The goal today is not only to pass more practice questions. The goal is to use four exam attempts as data and identify whether any weak areas are still repeating before booking the real exam.

## References

- Official sample questions:
  - https://learn.hashicorp.com/tutorials/terraform/associate-questions
- Terraform Associate review tutorial:
  - https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-review-003

## Practice Exam 3

- Questions attempted: `57`
- Correct: `56`
- Score: `98.2%`
- Time taken: `40 min`
- Result: `Pass`
- Full question set:
  - [practice_exam_3.md](./practice_exam_3.md)

### Questions Missed

#### Question 49

- Question: What is a custom variable validation block used for?
- Topic: Variable validation
- My answer: `A`
- Correct answer: `B`
- Why I was wrong: I treated validation like an external cloud or API check. Terraform variable validation is for enforcing rules on input values before the rest of the configuration is evaluated.
- Reinforcement: Variable validation checks user-provided values such as allowed environments, string patterns, numeric ranges, or CIDR shapes. It does not test whether a cloud API is reachable.

## Practice Exam 4

- Questions attempted: `57`
- Correct: `56`
- Score: `98.2%`
- Time taken: `45 min`
- Result: `Pass`
- Full question set:
  - [practice_exam_4.md](./practice_exam_4.md)

### Questions Missed

#### Question 12

- Question: Which source has higher precedence for input variable values?
- Topic: Variable value precedence
- My answer: `A`
- Correct answer: `B`
- Why I was wrong: I chose the variable default, but defaults have the lowest precedence. A value passed with `-var` on the CLI overrides defaults and automatically loaded variable files.
- Reinforcement: CLI-provided values such as `-var` and `-var-file` are high-precedence inputs. Defaults are fallback values only.

## Four-Exam Score Trend

| Exam | Score | % | Time Taken | Notes |
|---|---:|---:|---:|---|
| Exam 1 (Day 28) | `54/57` | `94.7%` | `55 min` | Passed; review focused on immutable infrastructure, Terraform purpose, and provider alias usage. |
| Exam 2 (Day 28) | `56/57` | `98.2%` | `50 min` | Passed; missed `terraform state mv` versus `terraform import`. |
| Exam 3 (Day 29) | `56/57` | `98.2%` | `40 min` | Passed; missed variable validation purpose. |
| Exam 4 (Day 29) | `56/57` | `98.2%` | `45 min` | Passed; missed variable precedence. |

## Trend Analysis

All four scores are comfortably above the 70% passing target. The last three practice exams are stable at `98.2%`, which suggests the core Terraform Associate knowledge is strong and consistent.

The trend is not plateauing below the target and it is not inconsistent. The main remaining work is light precision review, not broad relearning.

## Persistent Wrong Answer Review

Topics that appeared in wrong-answer analysis:

- Provider alias usage: missed on Day 28, answered correctly on Day 29.
- State refactoring commands: `terraform state mv` versus `terraform import` was missed on Day 28, then answered correctly on Day 29.
- Variable behavior: Day 29 had two misses in the variable area, one on validation and one on value precedence.

The only topic worth drilling again before the real exam is variable behavior:

- Variable validation enforces rules on input values.
- Defaults are fallback values and have the lowest precedence.
- CLI values such as `-var` override automatically loaded variable files.
- `terraform.tfvars` and `*.auto.tfvars` are loaded automatically from the root module.

## Targeted Revision Notes

No Terraform commands were run for Day 29. The review stayed in exam-simulation and documentation mode.

Before the real exam, do a short written drill:

1. Write the variable precedence order from memory.
2. Write one validation rule example for an `environment` variable.
3. Explain the difference between `terraform state mv`, `terraform state rm`, and `terraform import`.
4. Explain `provider = aws.west` on a resource and `providers = { aws = aws.west }` in a module block.

## Day 29 Takeaway

The four-exam trend shows readiness. The scores are high, stable, and well above the pass threshold. The final Day 30 preparation should focus on calm review, not heavy new material.
