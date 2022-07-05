module "vpc" {
  source = "../modules/vpc"

  vpc_name = "vpc-${var.environment}"
  vpc_cidr = var.vpc_cidr
  subnets = var.subnets
  route_table = var.route_table

  tags = {
    Environment = var.environment
  }
}
