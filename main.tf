# Create VPC
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

# Create Subnets
module "subnet" {
  source = "./modules/subnet"
  vpc_id               = module.vpc.vpc_id
  internet_gateway_id  = module.vpc.internet_gateway_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  project_name         = var.project_name
  environment          = var.environment
  tags                 = var.tags
}

# Create Security Groups
module "security_group" {
  source = "./modules/security_group"
  vpc_id                = module.vpc.vpc_id
  proxy_ingress_ports   = var.proxy_ingress_ports
  backend_ingress_ports = var.backend_ingress_ports
  project_name          = var.project_name
  environment           = var.environment
  tags                  = var.tags
}

# Create EC2 Instances
module "ec2" {
  source = "./modules/ec2"
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.subnet.public_subnet_ids
  private_subnet_ids      = module.subnet.private_subnet_ids
  proxy_security_group_id = module.security_group.proxy_security_group_id
  backend_security_group_id = module.security_group.backend_security_group_id
  key_name                = var.key_name
  proxy_instance_type     = var.proxy_instance_type
  backend_instance_type   = var.backend_instance_type
  proxy_ami               = var.proxy_ami
  backend_ami             = var.backend_ami
  project_name            = var.project_name
  environment             = var.environment
  private_key_path        = var.private_key_path
  tags                    = var.tags
}

# Create Load Balancer
module "elb" {
  source = "./modules/elb"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.subnet.public_subnet_ids
  elb_security_group_id = module.security_group.elb_security_group_id
  proxy_instance_ids    = module.ec2.proxy_instance_ids
  project_name          = var.project_name
  environment           = var.environment
  tags                  = var.tags
}

# Create Internal Application Load Balancer
module "internal_alb" {
  source                    = "./modules/internal-alb"
  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.subnet.private_subnet_ids
  backend_security_group_id = module.security_group.backend_security_group_id
  backend_instance_ids      = module.ec2.backend_instance_ids
  tags                      = var.tags
}
