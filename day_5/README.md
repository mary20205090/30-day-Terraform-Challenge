# Day 5 - Benefits of State and Load Balancing

This folder contains a Day 5 web app deployment that uses:

- an Application Load Balancer on port 80
- a Target Group with HTTP health checks
- a Launch Template
- an Auto Scaling Group
- outputs for the ALB DNS name

## What To Observe For The State Lab

After `terraform apply`, inspect the local state file:

```bash
terraform show
terraform state list
terraform state show aws_lb.example
terraform state show aws_autoscaling_group.example
```

Things to notice:

- Terraform tracks resource IDs, attributes, and outputs
- The state file maps Terraform resource names to real AWS resources
- If real infrastructure changes outside Terraform, `terraform plan` will show drift

## Task 3 Verification

After `terraform apply`:

1. Open the `alb_url` output in the browser
2. Confirm the page loads through the ALB
3. In AWS Console, stop one instance in the Auto Scaling Group
4. Confirm the ALB continues to serve traffic from the remaining healthy instance(s)
5. Watch the ASG replace the stopped instance

## Cleanup

```bash
terraform destroy
```
