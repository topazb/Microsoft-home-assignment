# Microsoft-home-assignment
automate infrastructure provisioning using Terraform, along with a YAML-based deployment configuration.

# Terraform AWS Infrastructure Provisioning

This Terraform project provisions a basic AWS infrastructure setup, including a VPC, public and private subnets, an EC2 instance, and an RDS instance. Secrets are managed securely in AWS Secrets Manager. This setup uses reusable modules and data resources to create a scalable and easily configurable infrastructure.

## Table of Contents
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Usage](#usage)
- [Outputs](#outputs)
- [Cleaning Up](#cleaning-up)
- [Troubleshooting](#troubleshooting)

---

## Project Overview

This infrastructure setup on AWS includes the following resources:
- **VPC** with public and private subnets
- **EC2 instance** in the public subnet, accessible via HTTP on port 80
- **RDS (MySQL) instance** in the private subnet
- **AWS Secrets Manager** to securely store the RDS instance's database password
- **IAM Role** to allow the EC2 instance to access secrets if needed

## Prerequisites

Before using this project, ensure you have the following:
- **AWS Account** with credentials that allow provisioning of these resources
- **Terraform** installed (version 0.12+ recommended)
- **AWS CLI** installed and configured
- **Access to create S3 buckets** (if using an S3 backend for state management)
  
## Project Structure

The project consists of a main configuration and a module for infrastructure components. Here’s a breakdown of the files and directories:

```plaintext
.
├── main.tf               # Main configuration file
├── providers.tf          # Provider configuration for AWS and Random
├── variables.tf          # Root-level variables for configuration
├── outputs.tf            # Outputs for resources created by the root module
└── modules/
    └── infrastructure/
        ├── main.tf       # Module's main configuration file
        ├── variables.tf  # Module's variables, specific to infrastructure
        ├── outputs.tf    # Module's outputs to be accessed by the root

```
## Configuration

### Variables

You can customize the infrastructure by setting values for the variables defined in `variables.tf` files. Defaults are provided for many variables, but you should review them to ensure they meet your needs.

The main configurable variables include:
- **region**: AWS region to deploy resources. Default is `us-east-1`.
- **vpc_cidr_block**: CIDR block for the VPC. Default is `10.0.0.0/16`.
- **public_subnet_cidr** and **private_subnet_cidr**: CIDR blocks for public and private subnets.
- **ami**: AMI ID for the EC2 instance. Adjust as needed based on your region.
- **db_name**: Name for the RDS database.
- **instance_type**: EC2 instance type (e.g., `t2.micro`).
  
### Sensitive Variables

The database password is generated securely using the `random` provider and stored in AWS Secrets Manager. You do not need to define it manually.

## Usage

### 1. Initialize Terraform

First, initialize Terraform to download necessary provider plugins and set up the working directory:

```terraform init```

### 2. Plan the Infrastructure

To view the resources that will be created and verify the configuration before applying the changes, run:

```terraform plan```

This command will show a preview of what Terraform intends to create based on your configuration.

### 3. Apply the Configuration

Once you're satisfied with the plan, apply the configuration to provision the resources on AWS. Terraform will prompt you for confirmation before proceeding:

```terraform apply```

Terraform will output the necessary details, including:
- Public IP of the EC2 instance
- VPC ID
- ARN of the secret in AWS Secrets Manager
- Database endpoint

### 4. Accessing the EC2 Instance

After deploying the infrastructure, you can SSH into the EC2 instance using its public IP address (provided in the output). Ensure your security group settings and SSH key are correctly configured to allow access.

## Outputs

The `outputs.tf` file in the root module provides important details after the infrastructure has been deployed. Key outputs include:

- `vpc_id`: The ID of the created VPC.
- `public_subnet_id`: The ID of the public subnet.
- `private_subnet_id`: The ID of the private subnet.
- `ec2_instance_public_ip`: The public IP address of the EC2 instance.
- `db_password_secret_arn`: The ARN of the stored secret in AWS Secrets Manager.
- `db_instance_endpoint`: The endpoint for the RDS database instance.

To view the outputs, use the following command:

```terraform output```

## Cleaning Up

To delete all resources created by this Terraform project, run:

```terraform destroy```

**Important**: This command will remove all provisioned resources, including data stored in the RDS instance. Ensure you back up any necessary data before executing this command.

## Troubleshooting

- **IAM Permissions**: Ensure the AWS user or role you're using has the necessary permissions to create VPCs, EC2 instances, RDS instances, and Secrets Manager resources.
- **EC2 SSH Access**: If you're unable to SSH into the EC2 instance, check that your security group allows inbound traffic on port 22 from your IP address.
- **Database Connectivity**: Ensure that the EC2 instance has network access to the RDS instance through the private subnet configuration.
