module "vpc" {
  source = "../../modules/vpc"

  vpc_name = "vpc-${var.environment}"
  vpc_cidr = var.vpc_cidr


  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  azs = [ for i, sbn in aws_subnet.public : "${var.region}${i+1}" ]

  tags = {
    Environment = var.environment
  }
}
