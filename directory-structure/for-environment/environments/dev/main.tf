module "vpc" {
  source = "../../modules/network"

  vpc_name = "vpc-${var.environment}"
  vpc_cidr = var.vpc_cidr

  subnets = var.subnets

  azs = [ "${var.region}a", "${var.region}c", "${var.region}d" ]

  tags = {
    Environment = var.environment
  }
}
