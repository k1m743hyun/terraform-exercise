module "vpc" {
  source = "../modules/vpc"

  vpc_name = "vpc-${var.environment}"
  vpc_cidr = var.vpc_cidr
  route_table = var.route_table
  subnets = var.subnets

  tags = {
    Environment = var.environment
  }
}
