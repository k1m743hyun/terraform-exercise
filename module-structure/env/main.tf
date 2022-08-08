module "vpc" {
  source = "../modules/vpc"

  vpc_name = "vpc-${var.environment}"
  vpc_cidr = var.vpc_cidr


  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  azs = [ "${var.region}a", "${var.region}c", "${var.region}d" ]

  tags = {
    Environment = var.environment
  }
}
