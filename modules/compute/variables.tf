variable "vpc_id" {
  description = "VPC ID for the instance"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

