# AWS CloudFormation Infrastructure Setup

This CloudFormation template creates an AWS infrastructure with the following resources:

- A Virtual Private Cloud (VPC) with 3 subnets (1 public and 2 private).
- An EC2 instance in the public subnet.
- An RDS instance in the private subnet with MySQL.
- Security configurations that allow:
  - HTTP traffic (port 80) to the EC2 instance.
  - Communication between the EC2 instance and the RDS instance.
  - An internet gateway for public subnet access.

## Prerequisites

Before deploying this CloudFormation template, ensure the following:

1. **AWS Account**: You must have an AWS account with sufficient permissions to create resources such as VPCs, EC2 instances, RDS instances, and Security Groups.
2. **Key Pair**: Make sure you have an existing EC2 key pair. Replace `"your-key-pair"` in the template with your actual key pair name.
3. **CloudFormation Console or CLI Access**: You can either use the AWS Management Console or AWS CLI to deploy the CloudFormation stack.

## Instructions

### Step 1: Create the CloudFormation Stack

#### Via AWS CLI:
1. Make sure to run from `Microsoft-Home-assignment/Task_2`.
2. Run the following CLI command: 
* **Change the values of `<your-key-pair-name>` and `<your-db-password>`**

```
aws cloudformation create-stack \
  --stack-name VPCWithEC2RDSStack \
  --template-body file://infrastructure.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=KeyName,ParameterValue=<your-key-pair-name> \
    ParameterKey=DBPassword,ParameterValue=<your-db-password>
```

#### Via AWS Console:
1. Log in to the [AWS Management Console](https://aws.amazon.com/console/).
2. Go to the **CloudFormation** service.
3. Click **Create stack**.
4. Choose **Upload a template file (`infrastructure.yaml`)** and upload the CloudFormation YAML file.
5. Enter a stack name (e.g., `VPCWithEC2RDSStack`).
6. Follow the prompts and click **Create stack**.


### Step 2: Access the EC2 Instance

After the stack is created successfully, the EC2 instance is running in the public subnet. You can access it via SSH using your key pair.

1. Get the public IP of the EC2 instance by running the following command:
```
aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress"
```

2. SSH into the EC2 instance:
```
ssh -i your-key-pair.pem ec2-user@<public-ip>
```

### Step 3: Access the RDS Database

The RDS instance is in a private subnet and cannot be accessed directly from the internet. However, the EC2 instance in the public subnet can communicate with the RDS instance.

- To connect to the RDS MySQL instance, SSH into the EC2 instance and use the `mysql` client to connect:

#### Install the MySQL client:
```bash
# Update the package index
sudo dnf update -y

# Install the MariaDB 10.5 client with auto "yes"
sudo dnf install -y mariadb105
```

```
mysql -h `aws rds describe-db-instances --query "DBInstances[?DBInstanceIdentifier=='myrdsinstance'].Endpoint.Address" --output text` -u admin -p
```

### Step 4: Cleanup

To delete the infrastructure:

```bash
aws cloudformation delete-stack --stack-name VPCWithEC2RDSStack
```
or
1. Go to the **CloudFormation Console**.
2. Select the stack you created.
3. Click **Delete Stack**.

This will terminate all resources, including the VPC, EC2, and RDS instances.
