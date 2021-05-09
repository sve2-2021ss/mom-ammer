provider "aws" {
  region = var.region
  shared_credentials_file = "$HOME/.aws/credentials"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name = var.name
  cidr = "10.99.0.0/18"

  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"]
  public_subnets = [
    "10.99.0.0/24",
    "10.99.1.0/24",
    "10.99.2.0/24"]
  private_subnets = [
    "10.99.3.0/24",
    "10.99.4.0/24",
    "10.99.5.0/24"]
  database_subnets = [
    "10.99.7.0/24",
    "10.99.8.0/24",
    "10.99.9.0/24"]

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name = var.name
  description = "PostgreSQL ${var.name} instance"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}

resource "aws_security_group" "sg" {
  vpc_id = module.vpc.vpc_id
}