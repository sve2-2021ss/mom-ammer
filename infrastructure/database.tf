# Adapted from https://github.com/terraform-aws-modules/terraform-aws-rds/blob/master/examples/complete-postgres/main.tf
module "db_default" {
  source = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = var.name

  create_db_option_group = false
  create_db_parameter_group = false

  engine = "postgres"
  engine_version = "11.11"
  family = "postgres11"
  major_engine_version = "11"
  instance_class = "db.t2.micro"

  allocated_storage = 20

  name = "feeder"
  username = "feeder"
  create_random_password = true
  random_password_length = 12
  port = 5432

  subnet_ids = module.vpc.database_subnets
  vpc_security_group_ids = [
    module.security_group.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:00-06:00"
  publicly_accessible = true

  backup_retention_period = 0
}