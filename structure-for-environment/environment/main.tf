module "vpc" {
  source = "../modules/network"

  vpc_name = "vpc-${var.environment}"
  vpc_cidr = var.vpc_cidr

  route_tables = toset([for k, v in var.subnets : k])

  subnets = concat(
    flatten([ for k, v in var.subnets : [ for c in v : join("-", [k, c]) ] if k == "public" ]),
    flatten([ for k, v in var.subnets : [ for c in v : join("-", [k, c]) ] if k == "private" ])
  )

  azs = [ "${var.region}a", "${var.region}c", "${var.region}d" ]

  tags = {
    Environment = var.environment
  }
}
