package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestHelloWorldApp(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/hello-world-app",
		Vars: map[string]interface{}{
			"cluster_name":     "test-cluster",
			"instance_type":    "t3.micro",
			"min_size":         1,
			"max_size":         1,
			"desired_capacity": 1,
			"environment":      "dev",
			"server_text":      "Hello from Day 16",
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	albDnsName := terraform.Output(t, terraformOptions, "alb_dns_name")
	url := "http://" + albDnsName

	http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello from Day 16", 30, 10*time.Second)
}
