output "proxy_security_group_id" {
  description = "ID of the proxy security group"
  value       = aws_security_group.proxy.id
}

output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend.id
}

output "elb_security_group_id" {
  description = "ID of the ELB security group"
  value       = aws_security_group.elb.id
}
