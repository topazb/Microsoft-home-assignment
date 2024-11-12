# RDS Database
resource "aws_db_instance" "db" {
  identifier             = var.db_name
  engine                 = "mysql"
  instance_class         = "db.t3.small"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = "admin"
  password               = random_password.db_password.result
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

# Secrets Manager for DB Password
resource "random_password" "db_password" {
  length  = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}|;:,.<>?" # Excludes '/', '@', '"', and spaces
}

resource "aws_secretsmanager_secret" "db_password_secret" {
  name = "${var.db_name}-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_password_secret.id
  secret_string = random_password.db_password.result
}
