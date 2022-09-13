variable "vpc_name" {}

variable "vpc_cidr" {}

#variable "vpc_cidr_secondary" {}

variable "route_tables" {}

variable "subnets" {}

variable "tags" {
  description = ""
  type        = map(string)
}