# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "AWS environment"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  type        = string
}

variable "azs" {
  description = "AWS Available Zone"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of CIDR Blocks for each Public Subnet"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR Blocks for each Private Subnet"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
