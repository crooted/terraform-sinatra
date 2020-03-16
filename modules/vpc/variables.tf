variable "availability_zones" {
  description = "List of availability zone names to create subnets within"
  default = [
    "ap-southeast-2a",
    "ap-southeast-2b",
    "ap-southeast-2c"
  ]
}

variable "subnet_address_bits" {
  description = "Number of bits to address per subnet"
  default = 8
}

variable "public_subnets_address_offset" {
  description = "Address start point creating public subnets"
  default = 0
}

variable "private_subnets_address_offset" {
  description = "Address start point for creating private subnets"
  default = 100
}

variable "name" {
  description = "Name of VPC, to be used in naming and tagging"
  default = "simple-sinatra"
}

variable "vpc_tags" {
  description = "Optional extra tag to add to the VPC"
  type = "map"
  default = {}
}
variable "subnet" {
  description = "Address space assigned to VPC configuration"
  default = "10.0.0.0/16"
}

variable "public_subnet_tags" {
  description = "Optional extra tag to add to the subnet"
  type = "map"
  default = {}
}

variable "private_subnet_tags" {
  description = "Optional extra tag to add to the subnet"
  type = "map"
  default = {}
}

variable "days_to_transition_to_ia" {
  description = "Days to transition objects in S3 bucket to standard infrequent access S3 class"
  default = 30
}

variable "enable_flow_logs" {
  description = "Toggle to turn vpc flow logs on/off"
  default = "false" # set to true to turn flow logs on and any other value to turn them off
}