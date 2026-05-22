terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Example VPC and Security Group for the inference server
resource "aws_vpc" "inference_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "inference-vpc"
  }
}

resource "aws_subnet" "inference_subnet" {
  vpc_id                  = aws_vpc.inference_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "inference-subnet"
  }
}

resource "aws_security_group" "inference_sg" {
  name        = "inference-security-group"
  description = "Allow inbound traffic for inference server"
  vpc_id      = aws_vpc.inference_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP API"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "inference-sg"
  }
}

# GPU-optimized EC2 Instance for Inference (e.g., g4dn.xlarge)
data "aws_ami" "ubuntu_dl" {
  most_recent = true
  owners      = ["898082745236"] # AWS Deep Learning AMI

  filter {
    name   = "name"
    values = ["Deep Learning AMI GPU PyTorch * (Ubuntu 20.04) *"]
  }
}

resource "aws_instance" "inference_server" {
  ami           = data.aws_ami.ubuntu_dl.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.inference_subnet.id

  vpc_security_group_ids = [aws_security_group.inference_sg.id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  tags = {
    Name = "model-inference-server"
    Environment = "Production"
  }
}
