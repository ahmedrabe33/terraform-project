variable "vpc_id" {
  description = "ID of the VPC"
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

variable "proxy_ingress_ports" {
  description = "List of ingress ports for proxy security group"
  type        = list(number)
}

variable "backend_ingress_ports" {
  description = "List of ingress ports for backend security group"
  type        = list(number)
}
