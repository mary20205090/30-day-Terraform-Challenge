Day 20 plan review (feature branch: `update-app-version-day20`)

Command run:

```bash
terraform -chdir=day_20/live/dev plan -out=day20.tfplan
terraform -chdir=day_20/live/dev show -no-color day20.tfplan
```

Summary:
- Plan: `15 to add, 0 to change, 0 to destroy`
- Expected app response version in user data: `Hello from Day 20 v3`
- No unexpected destroy actions

Validation:

```bash
terraform -chdir=day_20/live/dev validate
```

Result:
- `Success! The configuration is valid.`

Unit tests:

```bash
terraform -chdir=day_20/modules/services/webserver-cluster test
```

Result:
- `4 passed, 0 failed`
