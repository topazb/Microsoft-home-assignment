module "infrastructure" {
  source = "infrastructure"

  region                = "us-east-1"
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr_a = var.private_subnet_cidr_a
  private_subnet_cidr_b = var.private_subnet_cidr_b
  ami                   = var.ami
  instance_type         = var.instance_type
  instance_name         = var.instance_name
  db_name               = var.db_name
}
