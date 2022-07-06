variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
}

variable "subnets" {
  description = "A list of subnets inside the VPC"
  type        = map(any)
}

variable "route_table" {
  description = "A list of route tables inside the VPC"
  type        = map(any)
}

variable "tags" {}
