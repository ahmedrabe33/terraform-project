# Terraform project

> **Fully Automated AWS Infrastructure with Terraform**  
> Deploys a modular, highly available VPC network, bastion (proxy) & backend EC2 instances, and both Internet-facing and internal load balancers.

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)  
2. [Architecture Diagram](#architecture-diagram)  
3. [Getting Started](#getting-started)  
   - [Prerequisites](#prerequisites)  
   - [Directory Layout](#directory-layout)  
4. [Configuration](#configuration)  
   - [Variables](#variables)  
   - [Terraform Backend](#terraform-backend)  
5. [Usage](#usage)  
   1. [Initialize](#initialize)  
   2. [Validate](#validate)  
   3. [Plan](#plan)  
   4. [Apply](#apply)  
   5. [Destroy](#destroy)  
6. [Modules Breakdown](#modules-breakdown)  
7. [Inputs & Outputs](#inputs--outputs)   
8. [Contributing](#contributing)  
---

## Project Overview

This repository defines an AWS environment that includes:

- **VPC** with multiple public and private subnets across availability zones  
- **Bastion Host** (Proxy) in public subnets for secure SSH access  
- **Backend EC2 Instances** in private subnets running your application  
- **Internet-facing Classic ELB** routing to public instances  
- **Internal Application Load Balancer** routing to private backends  

Everything is built using reusable Terraform modules to ensure consistency, maintainability, and easy scaling.

---

## Architecture Diagram


![ChatGPT Image May 22, 2025, 01_23_11 PM](https://github.com/user-attachments/assets/e373beb7-d4bc-45d1-8d09-a93470a7ac2f)

---

## Getting Started ##

### Prerequisites

- Terraform v\<0.13\> or later  
- AWS CLI v2 configured with an IAM user/role that can create VPCs, EC2, ELB, S3 & DynamoDB  
- An existing S3 bucket & DynamoDB table for remote state locking


## Configuration

### Variables

Define defaults in `variables.tf` and override in `terraform.tfvars`:

## Terraform Backend

Configure remote state in backend.tf

## Usage

Run these commands from the repo root:

- terraform init
- terraform validate
- terraform plan
- terraform apply


##  Modules Breakdown

- Module	                           Purpose
- vpc	                  Creates VPC, IGW, NAT Gateways, route tables
- subnet	              Provisions public & private subnets across AZs
- security_group	      Defines security rules for bastion, backends, ELBs
- ec2	                  Launches bastion and backend instances with user data
- elb	                  Sets up an external Classic ELB for public access
- internal-alb	        Chooses an internal ALB for routing to private backends


## Inputs & Outputs
## Inputs

- Name	                            Description	                           Type	              Required
- project_name	            Prefix/tag for all resources	                string	               yes
- environment	              Deployment environment (dev, prod)	          string	               yes
- vpc_cidr	                CIDR block for VPC	                          string	               yes
- public_subnet_cidrs	      List of public subnet CIDRs per AZ	           list	                 yes
- private_subnet_cidrs	    List of private subnet CIDRs per AZ	           list	                 yes

## Outputs

- Name                          	Description
- vpc_id	                 The ID of the created VPC
- public_subnet_ids	       List of public subnet IDs
- private_subnet_ids	     List of private subnet IDs
- bastion_public_ips	     Public IP addresses of bastion hosts
- elb_dns_name	           DNS name of Internet-facing ELB
- internal_alb_dns_name    DNS name of internal Application Load Balancer


## Contributing 

- Fork this repository

- Create a feature branch: git checkout -b feature/<feature-name>

- Commit your changes: git commit -m "Add <feature>"

- Push: git push origin feature/<feature-name>

- Open a Pull Request and tag a reviewer
