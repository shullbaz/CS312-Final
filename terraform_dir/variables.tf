variable "aws_region" {
    default = "us-west-2"
  }

  variable "instance_type" {
    default = "t3.medium"
  }

  variable "key_pair_name" {
    description = "SSH key pair name (optional for development only)"
    type        = string
  }

  variable "ami_id" {
    description = "Ubuntu 22.04 AMI ID"
    default     = "ami-0ec1bf4a8f92e7bd1" # Update as needed
  }