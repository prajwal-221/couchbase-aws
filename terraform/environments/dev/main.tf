# VPC module
module "vpc" {
  source = "../../modules/vpc"
  name   = "couchbase-vpc"
  cidr_block = "10.0.0.0/16"
  private_subnets_cidrs = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets_cidrs  = ["10.0.0.0/24"]
  azs = ["us-west-1a","us-west-1b","us-west-1a"]
}

# Security group for couchbase nodes
module "sg" {
  source = "../../modules/security_group"
  name = "couchbase-sg"
  vpc_id = module.vpc.vpc_id
  admin_cidr = var.admin_cidr
  internal_cidr = "10.0.0.0/16"
}

# If you want Terraform to create the KeyPair resource from a public key file:
resource "aws_key_pair" "from_pub" {
  count = var.create_keypair_from_pub ? 1 : 0
  key_name   = "couchbase-deploy-key"
  public_key = file(var.public_key_path)
}

# Determine key name to use for EC2 module
locals {
  effective_key_name = var.create_keypair_from_pub ? aws_key_pair.from_pub[0].key_name : var.key_pair_name
}

# EC2 module - create N instances in public subnets for testing
module "ec2" {
  source = "../../modules/ec2"
  name = "couchbase-node"
  instance_count = 3
  instance_type  = "t3.medium"
  subnet_ids     = module.vpc.public_subnets   # <-- change here
  key_pair_name  = local.effective_key_name
  security_group_ids = [module.sg.sg_id]
  assign_public_ip = true  # needed for public subnet access
}

