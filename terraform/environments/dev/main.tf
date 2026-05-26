terraform {
  backend "s3" {
    #bucket         = "my-terraform-state2478v1"        #aws2
    #key            = "argocd/dev/terraform.tfstate"    # aws2
    bucket         = "my-terraform-state2478"         #aws1
    key            = "database-sre/dev/terraform.tfstate" #aws1
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    #profile = "aws2"
    profile = "aws1"
  }
}

# Key 

resource "aws_key_pair" "kube_lab_key" {
  key_name   = "kube-lab-key"
  public_key = file(pathexpand("~/.ssh/aws-kube-postgres.pub"))
}

# -------------------
# VPC
# -------------------

module "vpc" {
  source = "../../modules/vpc"

  name = var.name

  cidr = var.cidr

  public_azs = var.public_azs

  public_subnets = var.public_subnets

  tags = var.tags
}

# -------------------
# Security
# -------------------

module "security" {
  source = "../../modules/security"

  name = var.name

  vpc_id = module.vpc.vpc_id

  bucket_s3_arn = module.storage.bucket_s3_arn

  admin_cidr = var.admin_cidr

  tags = var.tags
}

module "compute" {
  source = "../../modules/compute"

  name = var.name
  
  key_name = aws_key_pair.kube_lab_key.key_name

  kube_instance_type = var.kube_instance_type

  instance_profile_name = module.security.kube_instance_profile_id
  
  subnet_id = module.vpc.public_subnets_id

  public_azs = var.public_azs
  
  kube_sg_id = module.security.kube_sg_id

  tags = var.tags
}


module "storage" {
  source = "../../modules/storage"

  name = var.name
  
  public_azs = var.public_azs

  #instance_id = module.compute.kube_instance_id

  tags = var.tags
}
