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

## Rolling Test Settings

1. Turn rolling-only mode on

In `variables.tf`, use:

```hcl
min_size                    = 1
max_size                    = 1
desired_capacity            = 1
app_version                 = "v1"
blue_green_min_size         = 0
blue_green_max_size         = 0
blue_green_desired_capacity = 0
active_environment          = "blue"
```

2. Run:

```bash
terraform apply
terraform output
```

3. Open the rolling URL only:

```text
http://<rolling_alb_dns_name>
```

Do not use port `8080` for the rolling test.

4. Change:

```hcl
app_version = "v1"
```

to:

```hcl
app_version = "v2"
```

5. Run:

```bash
terraform apply
```

6. Confirm the response changes from `Hello World v1` to `Hello World v2`.

## Blue/Green Test Settings

1. Turn blue/green back on

In `variables.tf`, change these to:

```hcl
blue_green_min_size         = 1
blue_green_max_size         = 1
blue_green_desired_capacity = 1
active_environment          = "blue"
```

2. Run:

```bash
terraform apply
terraform output
```

3. Open the blue/green URL:

```text
http://<blue_green_url_host>:8080
```

4. Confirm it serves `Blue environment v1`.

5. Change:

```hcl
active_environment = "blue"
```

to:

```hcl
active_environment = "green"
```

6. Run:

```bash
terraform apply
```

7. Confirm the response changes from `Blue environment v1` to `Green environment v2`.
