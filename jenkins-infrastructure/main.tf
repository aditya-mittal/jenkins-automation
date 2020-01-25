terraform {
  required_version = "0.12.19"

  backend "s3" {
    bucket  = "terraform-states"
    key     = "jenkins/us-east-1/terraform.tfstate"
    encrypt = true

    dynamodb_table = "terraform-lock-table"
    region         = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

locals {
  aws_region               = "us-east-1"
  jenkins_image_tag        = "TBD"
  name_prefix              = "jenkins"
  vpc_id                   = "TBD"
  public_subnet_us_east_1a = "TBD"
  common_tags = {
    CreatedBy             = "terraform"
  }
}

data "aws_vpc" "vpc" {
  id = local.vpc_id
}

data "aws_subnet" "public_us_east_1a" {
  id = local.public_subnet_us_east_1a
}