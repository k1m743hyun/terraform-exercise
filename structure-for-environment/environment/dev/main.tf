locals {
  availability_zones = [ for a in data.aws_availability_zones.available.names: a if try(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", a), false) != false ]
  public_subnets  = flatten([ for k, v in var.subnet_cidr : [ for c in v : join("-", [k, c]) ] if k == "public" ])
  private_subnets = flatten([ for k, v in var.subnet_cidr : [ for c in v : join("-", [k, c]) ] if k == "private" ])
}

module "vpc" {
  source             = "../../modules/vpc"

  vpc_name           = "${var.environment}-vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = local.availability_zones

  route_tables       = toset([for k, v in var.subnet_cidr : k])

  public_subnets     = local.public_subnets
  private_subnets    = local.private_subnets
  subnets            = concat(local.public_subnets, local.private_subnets)

  tags = {
    Environment = var.environment
  }
}

module "rds" {
  source              = "../../modules/rds"

  region              = var.region
  vpc_id              = module.vpc.vpc_id

  rds_az              = flatten([ for k, v in var.rds_config : [ for az in lookup(var.rds_config[k], "multi_az") : join("-", [k, az]) ] ])
  rds_value           = var.rds_config
  sg_rds_cidr         = var.sg_rds_cidr
  sg_rds_source       = var.sg_rds_source

  rds_master_username = var.rds_master_username
  rds_master_password = var.rds_master_password

  subnet_ids          = module.vpc.private_subnet_ids

  tags = {
    Environment = var.environment
  }
}

module "ecr" {
  source    = "../../modules/ecr"

  ecr_value = var.ecr_value

  tags = {
    Environment = var.environment
  }

}

module "eks" {
  source       = "../../modules/eks"

  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids

  ngroup_value = var.ngroup_value

  eks_oidc     = var.eks_oidc

  tags = {
    Environment = var.environment
  }
}
