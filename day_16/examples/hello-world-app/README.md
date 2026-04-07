# Day 16 Hello World Example

This example acts as:

- a manual test harness
- executable documentation
- the consumer for the Day 16 service modules

## Run

```bash
cd day_16/examples/hello-world-app
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

## Production Notes

- This example uses the default VPC for speed and simplicity.
- For real production use, you would normally use a custom VPC and tighter CIDR controls.
- For a real production stack, `prevent_destroy` should be enabled deliberately in code on truly critical resources such as state buckets or shared data stores.
