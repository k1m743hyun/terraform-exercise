module "network" {
  source = "../../modules/network"

  vpc_name = "vpc-${var.environment}"
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

  vpc_id = module.network.vpc_id

  rds_value = { for k, v in var.rds_config : [ for a in lookup(v, "multi_az", []) : join("-", [k, a]) ] => v }
  rds_sg_cidr = var.rds_sg_cidr
  rds_sg_source = var.rds_sg_source

  tags = {
    Environment = var.environment
  }
}

#module "application" {
#  source = "../../modules/application"
#}
