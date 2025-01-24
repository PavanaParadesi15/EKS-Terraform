// terraform script for VPC creation 
// Define the provider and the region where to create the resources
provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}
// defining the cluster name with a random string. Use this in eks-cluster.tf
locals {
  cluster_name = "new-eks-${random_string.suffix.result}"
}

// when eks cluster is created, name should be unique for each time we create   the cluster
resource "random_string" "suffix" {
  length  = 8
  special = false
}

// Using vpc module from official terraform aws modules. We can change the source path accordingly from where the module is being taken.
// provide version of the module and use latest version
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "new-eks-vpc"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}