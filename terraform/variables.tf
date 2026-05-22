variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (e.g., g4dn.xlarge for GPU inference)"
  type        = string
  default     = "g4dn.xlarge"
}

variable "key_name" {
  description = "SSH key pair name for EC2 access"
  type        = string
  default     = "my-inference-key"
}
