# General
region = "ap-northeast-1"
environment = "dev"


# Network
vpc_cidr = "10.0.0.0/16"
subnets  = {
    public = [
        "10.0.0.0/24",
        "10.0.1.0/24",
        "10.0.2.0/24"
    ]
    private = [
        "10.0.100.0/24",
        "10.0.101.0/24",
        "10.0.102.0/24"
    ]
}


# Database
rds_value = {
  "rds" = {
    cluster_identifier               = "rds"
    engine_version                   = "13.5"
    instance_class                   = "db.t2.micro"
    snapshot_identifier              = null
    multi_az                         = ["az2a", "az2c"]
    db_cluster_parameter_group_name  = "db-dev-rds-cluster"
    db_instance_parameter_group_name = "db-dev-rds-instance"
    apply_immediately                = true
    deletion_protection = true
  }
}




# Application
