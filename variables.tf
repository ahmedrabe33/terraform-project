# Global Variables
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

# Subnet Variables
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

# EC2 Variables
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

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

# Remote Backend Variables
variable "backend_s3_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "proxy_ingress_ports" {
  description = "List of ingress ports for proxy security group"
  type        = list(number)
}

variable "backend_ingress_ports" {
  description = "List of ingress ports for backend security group"
  type        = list(number)
}
