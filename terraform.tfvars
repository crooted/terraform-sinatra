# Root config
terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "simple-sinatra-app"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "ap-southeast-2"
      encrypt        = true
      dynamodb_table = "terraform-lock-table"
      profile        = "simple-sinatra-test"
    }
  }
}