resource "aws_iam_role" "ec2_role" {
  name               = "ec2-rds-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the policy to the IAM role that allows access to RDS and Secrets Manager
resource "aws_iam_role_policy" "ec2_rds_policy" {
  name   = "ec2-rds-policy"
  role   = aws_iam_role.ec2_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "rds:DescribeDBInstances",
          "rds:Connect",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "secretsmanager:GetSecretValue"
        Effect   = "Allow"
        Resource = "*"  # You can specify the ARN of your specific Secrets Manager secret here
      },
    ]
  })
}

# Create the IAM instance profile that links the IAM role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-rds-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instance
resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.instance_sg.id]
  tags = {
    Name = var.instance_name
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name # Attach IAM role
  depends_on = [aws_security_group.instance_sg] # Ensure security group is created first
}

