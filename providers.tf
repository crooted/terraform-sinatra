provider "aws" {
  alias   = "simple-sinatra"
  profile = "simple-sinatra"
  region  = "ap-southeast-2"
  version = "~> 2.53.0"
}
