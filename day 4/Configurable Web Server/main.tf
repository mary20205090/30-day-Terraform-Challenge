provider "aws" {
  region = var.region
}

# Use the default VPC so this lab stays focused on input variables rather
# than on building custom networking from scratch.
data "aws_vpc" "default" {
  default = true
}

# Query the default subnets in the chosen region and launch the instance
# into the first available subnet.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Look up a current Ubuntu AMI so the web server does not depend on a
# region-specific hardcoded AMI ID.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
  description = "Allow web traffic to the configurable web server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP traffic on the configured server port"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.server_name}-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -e
              apt-get update -y
              apt-get install -y python3
              mkdir -p /var/www/html
              cat > /var/www/html/index.html <<HTML
              <!DOCTYPE html>
              <html>
                <head>
                  <title>${var.server_name}</title>
                </head>
                <body>
                  <h1>${var.server_name}</h1>
                  <p>Environment: ${var.environment}</p>
                  <p>Region: ${var.region}</p>
                  <p>Server port: ${var.server_port}</p>
                </body>
              </html>
              HTML
              nohup python3 -m http.server ${var.server_port} --directory /var/www/html >/var/log/webserver.log 2>&1 &
              EOF

  tags = {
    Name        = var.server_name
    Environment = var.environment
    Terraform   = "true"
  }
}

output "public_ip" {
  description = "Public IP address of the configurable web server"
  value       = aws_instance.web_server.public_ip
}

output "public_dns" {
  description = "Public DNS name of the configurable web server"
  value       = aws_instance.web_server.public_dns
}

output "server_port" {
  description = "Port the server listens on"
  value       = var.server_port
}

output "server_url" {
  description = "HTTP URL for the configurable web server"
  value       = "http://${aws_instance.web_server.public_dns}:${var.server_port}"
}
