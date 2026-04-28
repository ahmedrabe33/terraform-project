# Security Group for Proxy Servers
resource "aws_security_group" "proxy" {
  name        = "${var.project_name}-${var.environment}-proxy-sg"
  description = "Security group for proxy servers"
  vpc_id      = var.vpc_id

  # Ingress rules for proxy servers
  dynamic "ingress" {
    for_each = var.proxy_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow port ${ingress.value}"
    }
  }

  # Egress rule for proxy servers
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-proxy-sg"
    }
  )
}

# Security Group for Backend Web Servers
resource "aws_security_group" "backend" {
  name        = "${var.project_name}-${var.environment}-backend-sg"
  description = "Security group for backend web servers"
  vpc_id      = var.vpc_id

  # Ingress rules for backend servers from proxy servers
  dynamic "ingress" {
    for_each = var.backend_ingress_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.proxy.id]
      description     = "Allow port ${ingress.value} from proxy servers"
    }
  }

  # Ingress rule for backend servers from internal ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    self            = true
    description     = "Allow HTTP from internal ALB (using same security group)"
  }

  # Egress rule for backend servers
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-backend-sg"
    }
  )
}

# Security Group for ELB
resource "aws_security_group" "elb" {
  name        = "${var.project_name}-${var.environment}-elb-sg"
  description = "Security group for load balancers"
  vpc_id      = var.vpc_id

  # Ingress rules for ELB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }

  # Egress rule for ELB
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-elb-sg"
    }
  )
}
