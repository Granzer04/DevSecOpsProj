######
# This provisions EKS Clusters on AWS
######
provider "aws" {
    region = "us-east-1"
    profile = "AdministratorAccess-240085965156"
}

# create VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = "my-vpc"
    }
}

# create subnet1
resource "aws_subnet" "subnet1" {
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}

# create subnet2
resource "aws_subnet" "subnet2" {
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}

# create EKS cluster within VPC
resource "aws_eks_cluster" "my_cluster" {
    name     = "my-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn
    
    vpc_config {
        subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
    }
}

# create IAM role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
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