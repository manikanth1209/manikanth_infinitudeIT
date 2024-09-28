provider "aws" {
  region     = "us-east-1"  # Specify your desired region
  access_key = "AKIA4HWJUG5M6WBGTW47"  # Your AWS Access Key (not recommended to hard-code)
  secret_key = "LHghWjzubL7VpFI6EG82EovwRwnaUn8D4KQv30Ia"  # Your AWS Secret Access Key (not recommended to hard-code)
}

# Use existing Subnet
data "aws_subnet" "existing" {
  id = "subnet-07ff8f2260b78831a"  # Your existing Subnet ID
}

# Use existing Security Group
data "aws_security_group" "existing" {
  id = "sg-0dcdd03bdfc4ac1f6"  # Your existing Security Group ID
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami                  = "ami-066784287e358dad1"  # Your desired AMI ID
  instance_type        = "t2.micro"
  subnet_id            = data.aws_subnet.existing.id
  vpc_security_group_ids = [data.aws_security_group.existing.id]  # Correct usage for VPC

  key_name             = "one"  # Your key pair name

  tags = {
    Name = "web-server"
  }
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name        = "my_api"
  description = "My API"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "GET"
  type                    = "MOCK"  # Use "HTTP" for real integration

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
}

output "api_url" {
  value = "${aws_api_gateway_rest_api.api.execution_arn}/v1/hello"
}
