package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFullStackEndToEnd(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()
	vpcName := fmt.Sprintf("day18-e2e-vpc-%s", strings.ToLower(uniqueID))
	clusterName := fmt.Sprintf("day18-e2e-app-%s", strings.ToLower(uniqueID))

	// This test deploys the full stack: fresh VPC first, then the app module
	// inside that VPC. That makes it broader than the integration test.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/full-stack",
		Vars: map[string]interface{}{
			"vpc_name":         vpcName,
			"cluster_name":     clusterName,
			"vpc_cidr":         "10.61.0.0/16",
			"instance_type":    "t3.micro",
			"environment":      "dev",
			"server_text":      "Hello from Day 18 End-to-End",
			"desired_capacity": 1,
			"min_size":         1,
			"max_size":         2,
			// These subnet CIDRs must live inside the VPC CIDR above.
			"public_subnet_cidrs": []string{
				"10.61.1.0/24",
				"10.61.2.0/24",
			},
		},
	})

	// The end-to-end test provisions the whole stack, so cleanup is mandatory.
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	publicSubnetIDs := terraform.OutputList(t, terraformOptions, "public_subnet_ids")
	albDNSName := terraform.Output(t, terraformOptions, "alb_dns_name")

	assert.NotEmpty(t, vpcID, "VPC ID should not be empty")
	assert.GreaterOrEqual(t, len(publicSubnetIDs), 2, "End-to-end stack should create at least two public subnets")

	// End-to-end means the outside HTTP path must work after the network and app
	// layers are both created.
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		fmt.Sprintf("http://%s", albDNSName),
		nil,
		60,
		10*time.Second,
		func(status int, body string) bool {
			return status == 200 && strings.Contains(body, "Hello from Day 18 End-to-End")
		},
	)
}
