variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(string)
}

variable "proxy_security_group_id" {
  description = "ID of the proxy security group"
  type        = string
}

variable "backend_security_group_id" {
  description = "ID of the backend security group"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "proxy_instance_type" {
  description = "Instance type for proxy servers"
  type        = string
}

variable "backend_instance_type" {
  description = "Instance type for backend web servers"
  type        = string
}

variable "proxy_ami" {
  description = "AMI ID for proxy servers"
  type        = string
}

variable "backend_ami" {
  description = "AMI ID for backend web servers"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}
