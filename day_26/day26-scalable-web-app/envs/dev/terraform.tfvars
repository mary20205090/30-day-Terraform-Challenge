app_name      = "day26-web"
environment   = "dev"
instance_type = "t3.micro"

min_size         = 1
max_size         = 4
desired_capacity = 2

cpu_scale_out_threshold = 70
cpu_scale_in_threshold  = 30
high_request_threshold  = 1000
enable_dashboard        = true

owner = "terraform-challenge"
