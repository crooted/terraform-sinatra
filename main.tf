terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
  required_version = "0.11.14"
}

module "vpc" {
  source                          =  "./modules/vpc"
  name                            = "simple-sinatra-vpc"
  enable_flow_logs                = "false"
  subnet                          = "10.100.0.0/16"
}
