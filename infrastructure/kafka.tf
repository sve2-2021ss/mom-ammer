resource "aws_kms_key" "kms" {
  description = var.name
}

resource "aws_cloudwatch_log_group" "brokerlytics" {
  name = "msk_broker_logs"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "msk-${var.name}-logs-bucket"
  acl = "private"
  force_destroy = true
}

resource "aws_msk_cluster" "brokerlytics" {
  cluster_name = var.name
  kafka_version = "2.8.0"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type = "kafka.t3.small"
    ebs_volume_size = 20
    client_subnets = module.vpc.public_subnets
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