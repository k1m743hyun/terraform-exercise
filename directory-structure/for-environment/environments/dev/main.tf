module "vpc" {
  source = "../../modules/network"

  vpc_name = "vpc-${var.environment}"
  vpc_cidr = var.vpc_cidr

  for_each = var.subnets
  subnet_type  = each.key
  subnet_cidr = each.value

  azs = [ "${var.region}a", "${var.region}c", "${var.region}d" ]

  tags = {
    Environment = var.environment
  }
}
