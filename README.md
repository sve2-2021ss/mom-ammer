# Brokerlytics

Second exercise for the subject 20_SVE2UE at FH OÖ Campus Hagenberg. The exercise is based on Amazon Managed Streaming for Apache Kafka and uses the kafka-python library for the producers and consumers.

## tl;dr

After implementing the three services I had to find out that the MSK does not expose public endpoints according to their [FAQ](https://aws.amazon.com/msk/faqs/):

> **Q: Is the connection between my clients and an Amazon MSK cluster always private?**
Yes, the only way data can be produced and consumed from an Amazon MSK cluster is over a private connection between your clients in your VPC, and the Amazon MSK cluster. Amazon MSK does not support public endpoints.

There are solutions to bypass this problem ([VPC Peering, Direct Connect, VPN](https://docs.aws.amazon.com/msk/latest/developerguide/client-access.html) or [Elastic IPs](https://repetitive.it/aws-msk-how-to-expose-the-cluster-on-the-public-network/?lang=en)) but this approaches are either an overkill for such a demo project or not easy to automate. Another downside is that MSK does not support auto-scaling for brokers but only for storage.

## 🚩 Goal

*tbd*

## 🏗 Architecture

*tbd*

## 📝 Requirements

* `awscli`

## 🚀 Get started

*tbd*

## Resume