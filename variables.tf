
variable "simple_sinatra_instance" {
  type = "map"
  default = {
    ami = "ami-01393ce9a3ca55d67"
    type = "t2.micro"
    root_vol = "8"
    key_name = "personal"
  }
}



