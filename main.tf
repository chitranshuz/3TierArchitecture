provider "aws" {
  access_key = "<my-access-key>"
  secret_key = "<my-secret-key>"
  profile    = "production"
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    #  Replace this with your bucket name!
    bucket                  = module.tf-backend.backend_bucket
    key                     = "terraform.tfstate"
    access_key              = "<my-access-key>"
    secret_key              = "<my-secret-key>"
    profile                 = "production"
    region                  = "us-east-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = module.tf-backend.backend_dynamodb
    encrypt        = true
 }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.84.0"
    }
  }
}

module "tf-backend" {
    source = "./module/backend"
}

module "network"{
  source = "./module/netwrok"
}

module "compute"{
  source = "./module/compute"
  private_subnet = module.network.private_subnet
  public_subnet = module.network.public_subnet 
  vpc_name = module.network.vpc_name 
  db_address = module.database.db_address
}

module "database" {
  source = "./module/database"
  private_subnet = module.network.private_subnet
  private_subnet_t = module.network.private_sub_t
  vpc_name = module.network.vpc_name
}
