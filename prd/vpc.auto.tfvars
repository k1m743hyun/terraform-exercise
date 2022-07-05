vpc_cidr = "10.0.0.0/16"

route_table = {
  "main" = {
    name = "main"
  }
}

subnets = {
  "a" = {
    name        = "a"
    cidr_block  = "10.0.0.0/24"
    route_table = "main"
  },
  "b" = {
    name        = "b"
    cidr_block  = "10.0.1.0/24"
    route_table = "main"
  },
  "c" = {
    name        = "c"
    cidr_block  = "10.0.2.0/24"
    route_table = "main"
  }
}
