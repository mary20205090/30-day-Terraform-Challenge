package test

import (
	"strings"
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

	// The app returns a small HTML page, so validate by status code plus a body substring.
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 60, 10*time.Second, func(statusCode int, body string) bool {
		return statusCode == 200 && strings.Contains(body, "Hello from Day 16")
	})
}
