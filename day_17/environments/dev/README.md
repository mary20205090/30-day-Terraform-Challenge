# Day 17 Dev Environment

This root module is the development target for the Day 17 manual test suite.

It exists to let you:

- run the structured checklist in a cheaper environment first
- record expected behavior
- compare dev results against production

## Run

```bash
cd day_17/environments/dev
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform plan
terraform plan -destroy
terraform destroy
```
