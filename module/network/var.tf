variable "cidr" {
  default = "10.0.0.0/16"
}

variable "vpcname" {
  default = "prod-vpc"
}

variable "cidr_sub_pub" {
  default = "10.0.0.0/24"
}

variable "cidr_sub_pri" {
  default = "10.0.1.0/24"
}

variable "cidr_sub_pri_t" {
  default = "10.0.2.0/24"
}