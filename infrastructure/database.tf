resource "aws_db_instance" "default" {
  allocated_storage = 10
  engine = "mariadb"
  engine_version = "10.5"
  auto_minor_version_upgrade = true
  instance_class = "db.t2.micro"
  name = "brokerlytics"
  username = "brokerlytics-admin"
  password = "brokerlytics"
  skip_final_snapshot = true
}