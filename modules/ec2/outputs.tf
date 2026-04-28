output "proxy_instance_ids" {
  description = "IDs of the proxy instances"
  value       = aws_instance.proxy[*].id
}

output "backend_instance_ids" {
  description = "IDs of the backend instances"
  value       = aws_instance.backend[*].id
}

output "proxy_public_ips" {
  description = "Public IPs of the proxy instances"
  value       = aws_instance.proxy[*].public_ip
}

output "proxy_private_ips" {
  description = "Private IPs of the proxy instances"
  value       = aws_instance.proxy[*].private_ip
}

output "backend_private_ips" {
  description = "Private IPs of the backend instances"
  value       = aws_instance.backend[*].private_ip
}
