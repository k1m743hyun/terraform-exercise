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



# Application
