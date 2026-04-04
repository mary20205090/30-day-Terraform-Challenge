# Day 12: Zero-Downtime Deployments with Terraform

Day 12 is a standalone lab for learning two related deployment patterns:

- rolling replacement with `create_before_destroy`
- blue/green switching at the load balancer

## Files

- `main.tf` - ALB, target groups, launch templates, ASGs, and listener logic
- `variables.tf` - deployment inputs such as `app_version` and `active_environment`
- `outputs.tf` - the URLs and key resource names needed for testing
- `user-data.sh.tftpl` - lightweight app script that returns a visible version string

## What This Day Demonstrates

- why Terraform's default replacement order causes downtime
- how `create_before_destroy` reverses the order safely
- why ASGs need unique names when old and new copies coexist
- how `random_id` helps trigger safe ASG replacement
- how blue/green switching works with a listener rule and two target groups

## Testing Order

Run the Day 12 demos in this order on small AWS quotas:

1. Test the rolling deployment first with blue/green capacity set to `0`
2. Confirm the `v1` to `v2` transition on the main ALB URL (port `80`)
3. Then scale blue/green capacity back to `1`
4. Test the listener switch on the blue/green URL (port `8080`)
5. Use `curl` or a hard browser refresh when testing the blue/green switch so you don't mistake a cached page for the old environment

This avoids running all overlapping instances at the same time.
