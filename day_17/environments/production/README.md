# Day 17 Production Environment

This root module is the production-flavored target for the Day 17 manual test
suite.

It keeps the same reusable modules as dev, but uses production-style settings
such as a larger desired capacity.

## Run

```bash
cd day_17/environments/production
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform plan
terraform plan -destroy
terraform destroy
```
