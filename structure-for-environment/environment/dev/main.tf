module "network" {
  source = "../../modules/network"

  vpc_name = "${var.environment}-vpc"
  vpc_cidr = var.vpc_cidr

  route_tables = toset([for k, v in var.subnet_cidr : k])

  availability_zone = data.aws_availability_zones.available.names

  subnets = concat(
    flatten([ for k, v in var.subnet_cidr : [ for c in v : join("-", [k, c]) ] if k == "public" ]),
    flatten([ for k, v in var.subnet_cidr : [ for c in v : join("-", [k, c]) ] if k == "private" ])
  )

  tags = {
    Environment = var.environment
  }
}

module "database" {
  source = "../../modules/database"

  region = var.region
  vpc_id = module.network.vpc_id

  rds_az = flatten([ for k, v in var.rds_config : [ for az in lookup(var.rds_config[k], "multi_az") : join("-", [k, az]) ] ])
  rds_value = var.rds_config
  sg_rds_cidr = var.sg_rds_cidr
  sg_rds_source = var.sg_rds_source

  rds_master_username = var.rds_master_username
  rds_master_password = var.rds_master_password

  subnet_ids = module.network.private_subnet_ids

  tags = {
    Environment = var.environment
  }
}

module "application" {
  source = "../../modules/application"

  vpc_id = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids

  ngroup_value = var.ngroup_value
  ecr_value = var.ecr_value
  eks_oidc = var.eks_oidc

  tags = {
    Environment = var.environment
  }
}
