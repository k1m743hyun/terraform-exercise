variable "vpc_name" {}

variable "vpc_cidr" {}

#variable "vpc_cidr_secondary" {}

variable "azs" {
  description = ""
  type        = list(string)
}

variable "subnet_type" {}

variable "subnet_cidr" {}

variable "tags" {
  description = ""
  type        = map(string)
}