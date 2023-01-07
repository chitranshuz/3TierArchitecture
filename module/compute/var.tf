variable "private_subnet"{}

variable "public_subnet"{}

variable "vpc_name" {}

variable "db_address" {}

variable "key_name" {
  default = "mykey"
}

variable "security_group" {
  default = "sg"
}