terraform {
  backend "s3" {
    bucket = "ycc-terraform-state-prod"
    key    = "first-try/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "aws_networking_setup" {
  source = "./modules/aws-networking-setup"

  aws_region = "eu-central-1"
  aws_az_list = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  instance_type = "t2.micro"
}

module "kops_master" {
    source = "./modules/kops-master"
    vpc = module.aws_networking_setup.vpc
    subnet = module.aws_networking_setup.public-subnet-1-id
    security_group = module.aws_networking_setup.sg-allow-web
}