# Day 15: Working with Multiple Providers - Part 2

Day 15 finishes Chapter 7 by moving from provider basics into real multi-provider patterns.

Today covers three practical ideas:

- reusable modules that accept provider configurations from their callers
- managing a local Docker container with Terraform
- using AWS and Kubernetes providers together for an EKS deployment

## Folder Layout

This day is split into separate folders on purpose so you can run the labs one at a time:

- `modules/multi-region-app`
  - reusable module that expects aliased AWS providers
- `live/multi-region`
  - root module that passes those provider aliases into the reusable module
- `docker-local`
  - local Docker lab for a quick multi-provider win with low risk
- `eks`
  - AWS + Kubernetes lab for EKS and a deployed workload
- `multi_account_example.tf.example`
  - reference-only pattern for `assume_role`

## The Most Important Day 15 Idea

Reusable modules should not define their own provider blocks.

Instead:

- the root module owns provider configuration
- child modules declare what providers they expect
- the root module passes the right providers in

That is why the reusable module in `modules/multi-region-app` uses:

- `required_providers`
- `configuration_aliases`

And the root module in `live/multi-region` uses:

- `providers = { ... }`

## Lab 1: Module That Works with Multiple Providers

### What it demonstrates

- one reusable module
- two aliased AWS providers
- one S3 bucket in the primary region
- one S3 bucket in the replica region

### Files

- `modules/multi-region-app/main.tf`
- `modules/multi-region-app/variables.tf`
- `modules/multi-region-app/outputs.tf`
- `live/multi-region/main.tf`
- `live/multi-region/variables.tf`
- `live/multi-region/outputs.tf`

### Command order

Run these yourself:

```bash
cd day_15/live/multi-region
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

### What to notice

- the module has no provider blocks
- the root module defines both providers
- the module call wires them in explicitly
- the buckets should appear in two AWS regions

## Lab 2: Docker Provider

### What it demonstrates

- Terraform can manage local containers too
- the Docker provider is a real provider just like AWS

### Files

- `docker-local/main.tf`
- `docker-local/variables.tf`
- `docker-local/outputs.tf`

### Before you run it

Make sure Docker Desktop or the Docker daemon is running locally.

### Command order

```bash
cd day_15/docker-local
terraform init
terraform validate
terraform plan
terraform apply
terraform output
```

Then test in the browser:

- `http://localhost:8080`

Or:

```bash
curl http://localhost:8080
```

When you are finished:

```bash
terraform destroy
```

## Lab 3: AWS + Kubernetes on EKS

### What it demonstrates

- AWS provider creates cloud infrastructure
- Kubernetes provider deploys the app into the cluster
- one Terraform configuration can use multiple provider types together

### Files

- `eks/main.tf`
- `eks/variables.tf`
- `eks/outputs.tf`

### Cost warning

This is the expensive part of Day 15.

Even for a short lab, EKS can cost money because:

- the EKS control plane itself is billed
- worker nodes are billed
- any load balancer created by the Kubernetes Service is billed

Destroy this lab as soon as you finish.

### Important practical note

This lab uses public subnets for the node group to avoid NAT gateway charges during learning.

That is cheaper, but it is not the networking layout you would normally prefer in production.

Production would usually use:

- private worker subnets
- controlled egress
- stronger network boundaries

### Safer run order

Because the Kubernetes provider depends on the EKS cluster being reachable, the cleanest learning flow is:

1. create the AWS infrastructure first
2. confirm the cluster is ready
3. then apply again so the Kubernetes resources deploy

Run these yourself:

```bash
cd day_15/eks
terraform init
terraform validate
terraform plan
terraform apply -target=module.vpc -target=module.eks
```

After the cluster is created, update your kubeconfig:

```bash
aws eks update-kubeconfig --region us-east-1 --name terraform-challenge-cluster
```

Then finish the Kubernetes deployment:

```bash
terraform apply
terraform output
kubectl get nodes
kubectl get svc -n day15
```

When you are done:

```bash
terraform destroy
```

## Multi-Account Pattern

If you do not have cross-account roles yet, do not try to run the multi-account example.

Instead, read:

- `multi_account_example.tf.example`

That file shows the correct `assume_role` pattern without breaking the runnable labs.

## Key Learnings from Chapter 7

### 1. `provider` vs `providers`

- `provider` is for a single resource or data source
- `providers` is for a module

### 2. `configuration_aliases`

This tells Terraform which aliased provider configurations a child module expects to receive.

### 3. Docker

- image = packaged app
- container = running copy of that app

### 4. Kubernetes

- Deployment = how many app replicas should run
- Service = how traffic reaches the app

### 5. EKS

EKS is where Terraform becomes truly multi-provider:

- AWS provider builds the cluster
- Kubernetes provider deploys the workload

## Best-Practice Notes

- keep provider configuration in the root module
- keep reusable modules provider-agnostic
- use aliases only when you truly need multiple provider configurations
- separate expensive labs from cheap ones
- destroy cloud resources immediately after validation

## My Main Takeaway

Day 15 is really about control.

You are learning how to control:

- which provider a module uses
- which region a resource goes to
- which platform each part of the code talks to

Once that clicks, multi-region and multi-provider Terraform starts to feel much more understandable.
