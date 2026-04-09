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

func TestWebserverClusterIntegration(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()
	clusterName := fmt.Sprintf("day18-int-%s", strings.ToLower(uniqueID))

	// This test uses the lightweight example root module, which reuses the
	// default VPC and focuses on whether the app modules work together in AWS.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/webserver-cluster",
		Vars: map[string]interface{}{
			"cluster_name":     clusterName,
			"instance_type":    "t3.micro",
			"min_size":         1,
			"max_size":         2,
			"desired_capacity": 1,
			"environment":      "dev",
			"server_text":      "Hello from Day 18 Integration",
		},
	})

	// Always clean up real AWS resources, even if the test fails midway through.
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	albDNSName := terraform.Output(t, terraformOptions, "alb_dns_name")
	asgName := terraform.Output(t, terraformOptions, "asg_name")
	url := fmt.Sprintf("http://%s", albDNSName)

	// Integration tests should prove the composed module is reachable, not just
	// that Terraform returned outputs.
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 60, 10*time.Second, func(status int, body string) bool {
		return status == 200 && strings.Contains(body, "Hello from Day 18 Integration")
	})

	assert.NotEmpty(t, albDNSName, "ALB DNS name should not be empty")
	assert.NotEmpty(t, asgName, "ASG name should not be empty")
}
