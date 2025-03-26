variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-west-2"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "my-key"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

