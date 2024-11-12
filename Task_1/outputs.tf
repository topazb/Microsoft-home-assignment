output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.infrastructure.ec2_instance_public_ip
}

output "db_password_secret_arn" {
  description = "ARN of the RDS database password stored in Secrets Manager"
  value       = module.infrastructure.db_password_secret_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.infrastructure.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.infrastructure.public_subnet_id
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS database instance"
  value       = module.infrastructure.db_instance_endpoint
}
