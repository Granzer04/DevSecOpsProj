######
# This provisions EKS Clusters on AWS
######
provider "aws" {
    region = "us-east-1"
}

resource "aws_eks_cluster" "my_cluster" {
    name    = "devsecops-cluster"
    role_arn = aws_iam_role.eks_role.role_arn

    vpc_config {
      subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    }
}

resource "aws_iam_role" "eks_role" {
    name    = "eks-role"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}