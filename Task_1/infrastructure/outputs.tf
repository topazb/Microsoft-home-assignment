output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "db_password_secret_arn" {
  value = aws_secretsmanager_secret.db_password_secret.arn
}

output "db_instance_endpoint" {
  value = aws_db_instance.db.endpoint
}