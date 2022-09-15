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
  tags = {
    Environment = var.environment
  }
}

#module "application" {
#  source = "../../modules/application"
#}
