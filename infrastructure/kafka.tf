terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/22"
}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_subnet" "subnet_az1" {
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block = "192.168.0.0/24"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_az2" {
  availability_zone = data.aws_availability_zones.azs.names[1]
  cidr_block = "192.168.1.0/24"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_kms_key" "kms" {
  description = "brokerlytics"
}

resource "aws_cloudwatch_log_group" "brokerlytics" {
  name = "msk_broker_logs"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "msk-brokerlytics-logs-bucket"
  acl = "private"
  force_destroy = true
}

resource "aws_msk_cluster" "brokerlytics" {
  cluster_name = "brokerlytics"
  kafka_version = "2.8.0"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    ebs_volume_size = 20
    client_subnets = [
      aws_subnet.subnet_az1.id,
      aws_subnet.subnet_az2.id,
    ]
    security_groups = [
      aws_security_group.sg.id]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled = true
        log_group = aws_cloudwatch_log_group.brokerlytics.name
      }
      s3 {
        enabled = true
        bucket = aws_s3_bucket.bucket.id
        prefix = "logs/msk-"
      }
    }
  }
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.brokerlytics.zookeeper_connect_string
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value = aws_msk_cluster.brokerlytics.bootstrap_brokers_tls
}