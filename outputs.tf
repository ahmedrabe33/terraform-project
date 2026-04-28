output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.subnet.private_subnet_ids
}

output "proxy_security_group_id" {
  description = "ID of the proxy security group"
  value       = module.security_group.proxy_security_group_id
}

output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = module.security_group.backend_security_group_id
}

output "elb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.elb.lb_dns_name
}

output "proxy_public_ips" {
  description = "Public IPs of the proxy instances"
  value       = module.ec2.proxy_public_ips
}

output "proxy_private_ips" {
  description = "Private IPs of the proxy instances"
  value       = module.ec2.proxy_private_ips
}

output "backend_private_ips" {
  description = "Private IPs of the backend instances"
  value       = module.ec2.backend_private_ips
}

# Generate a local file with all server IPs
resource "local_file" "server_ips" {
  content = <<-EOF
    # Terraform AWS Lab - Server IPs
    
    ## Load Balancer
    ELB DNS Name: ${module.elb.lb_dns_name}
    
    ## Proxy Servers
    ${join("\n", [
      for i, ip in module.ec2.proxy_public_ips :
      "Proxy Server ${i + 1}:\n  Public IP: ${ip}\n  Private IP: ${module.ec2.proxy_private_ips[i]}"
    ])}
    
    ## Backend Servers
    ${join("\n", [
      for i, ip in module.ec2.backend_private_ips :
      "Backend Server ${i + 1}:\n  Private IP: ${ip}"
    ])}
  EOF
  
  filename = "${path.module}/server_ips.txt"
}
