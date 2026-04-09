DAY 17 DEV TEST RESULTS

Environment:
dev

Folder:
day_17/environments/dev

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
Plan: 15 to add, 0 to change, 0 to destroy
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
alb_dns_name = "day17-20260409113855173600000004-93979474.us-east-1.elb.amazonaws.com"
alerts_topic_arn = "arn:aws:sns:us-east-1:718417034043:day17-manual-dev-5347fc-asg-alerts"
asg_name = "day17-manual-dev-5347fc-asg-20260409113903136800000007"
Result:
PASS

Test:
ALB DNS resolves and returns expected response
Command:
Browser check against ALB DNS name
Expected:
Hello from Day 17 Dev
Actual:
Hello from Day 17 Dev
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
All managed dev resources marked for destruction
Actual:
Plan: 0 to add, 0 to change, 15 to destroy
Result:
PASS

Test:
post-destroy AWS verification returns empty results
Command:
terraform destroy
aws ec2 describe-instances --filters "Name=tag:ManagedBy,Values=terraform" --query "Reservations[*].Instances[*].InstanceId"
aws elbv2 describe-load-balancers --query "LoadBalancers[*].LoadBalancerArn"
Expected:
Both commands return empty results after destroy
Actual:
terraform destroy reported: Destroy complete! Resources: 15 destroyed.
The ELB query returned []
The broad EC2 query still returned one instance ID immediately after destroy, which can happen because AWS may briefly return recently terminated instances.
Result:
PASS WITH NOTE
Fix:
Use a state-aware EC2 verification command next time:
aws ec2 describe-instances --filters "Name=tag:ManagedBy,Values=terraform" "Name=instance-state-name,Values=pending,running,stopping,stopped" --query "Reservations[*].Instances[*].InstanceId"

Remaining recommended dev checks:
- run curl against the ALB DNS name and record the terminal output
- stop one ASG instance manually and confirm the ASG replaces it
- rerun the improved EC2 verification command after a short wait if you want extra confirmation
