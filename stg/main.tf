module "vpc" {
  source = "../modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  subnets = {
    "a" = {
      name       = "a"
      cidr_block = "10.0.0.0/24"
    },
    "b" = {
      name       = "b"
      cidr_block = "10.0.1.0/24"
    },
    "c" = {
      name       = "c"
      cidr_block = "10.0.2.0/24"
    }
  }

  tags = {
    Environment = var.environment
  }
}
