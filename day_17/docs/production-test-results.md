DAY 17 PRODUCTION TEST RESULTS

Environment:
production

Folder:
day_17/environments/production

Date:
2026-04-09

Test:
terraform init completes without errors
Command:
terraform init
Expected:
Initialization completes successfully
Actual:
Initialization completed successfully
Result:
PASS

Test:
terraform validate passes cleanly
Command:
terraform validate
Expected:
Success message with no validation errors
Actual:
Validation passed
Result:
PASS

Test:
terraform plan shows expected resources
Command:
terraform plan
Expected:
ALB, target group, ASG, launch template, security groups, SNS topic, and CloudWatch alarm
Actual:
Plan reviewed and matched the expected production resources
Result:
PASS

Test:
terraform apply completes without errors
Command:
terraform apply
Expected:
Resources created successfully
Actual:
Apply completed successfully
Result:
PASS

Test:
terraform output returns expected values
Command:
terraform output
Expected:
ALB DNS name, alerts topic ARN, and ASG name
Actual:
Outputs were populated successfully
Result:
PASS

Test:
ALB DNS resolves and returns expected response
Command:
Browser check and curl against ALB DNS name
Expected:
Hello from Day 17 Production
Actual:
Hello from Day 17 Production
Result:
PASS

Test:
terraform plan returns clean after apply
Command:
terraform plan
Expected:
No changes. Your infrastructure matches the configuration.
Actual:
No changes. Your infrastructure matches the configuration.
Result:
PASS

Test:
terraform plan -destroy previews full cleanup
Command:
terraform plan -destroy
Expected:
All managed production resources marked for destruction
Actual:
Destroy plan reviewed successfully
Result:
PASS

Test:
terraform destroy removes production resources
Command:
terraform destroy
Expected:
Destroy completes without errors
Actual:
Destroy completed successfully
Result:
PASS

Test:
post-destroy AWS verification returns empty results for active resources
Command:
aws ec2 describe-instances --filters "Name=tag:ManagedBy,Values=terraform" "Name=instance-state-name,Values=pending,running,stopping,stopped" --query "Reservations[*].Instances[*].InstanceId"
aws elbv2 describe-load-balancers --query "LoadBalancers[*].LoadBalancerArn"
Expected:
Both commands return empty results
Actual:
Cleanup verification completed after destroy
Result:
PASS

Environment comparison note:
- dev and production both behaved as expected
- production returned the correct production page content
- production used larger ASG sizing than dev without introducing unexpected behavior
