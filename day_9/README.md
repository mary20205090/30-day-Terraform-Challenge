# Day 9: Advanced Terraform Modules

Day 9 builds on Day 8 by focusing on:

- module gotchas
- version pinning
- multi-environment reuse with different module versions

## Structure

- `live/dev/services/webserver-cluster/main.tf`
- `live/production/services/webserver-cluster/main.tf`

These root configurations consume a versioned module source from Git by
using the `?ref=` pattern.

## Important Note

For this lab, the source points to the Day 8 module folder inside the main
challenge repository by using a double-slash path to the subdirectory.
