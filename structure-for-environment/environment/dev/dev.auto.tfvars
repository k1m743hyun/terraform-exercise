# General
region = "ap-northeast-1"
environment = "dev"


# Network
vpc_cidr = "10.0.0.0/16"
subnet_cidr  = {
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
rds_config = {
  "rds" = {
    cluster_identifier               = "rds"
    instance_class                   = "db.t3.xlarge"
    snapshot_identifier              = null
    multi_az                         = ["az2a", "az2c"]
    db_cluster_parameter_group_name  = "parmetg-dev-rds-cluster"
    db_instance_parameter_group_name = "parmetg-dev-rds-instance"
    apply_immediately                = true
    deletion_protection = true
  }
}

rds_sg_cidr = {
  # ingress
  "ingress_5432" = {
    type        = "ingress"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "ingress all"
  },
  # egress
  "egress_5432" = {
    type        = "egress"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "egress all"
  }
}

rds_sg_source = {

}


# Application
