variable "project_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "backend_security_group_id" {}
variable "backend_instance_ids" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}