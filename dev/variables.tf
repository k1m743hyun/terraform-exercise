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

variable "vpc_cidr" {}

variable "subnets" {}

variable "route_table" {}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
