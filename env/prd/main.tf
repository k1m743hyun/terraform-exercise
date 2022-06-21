module "vpc" {
    source = "../../modules/vpc"
    
    name            = var.name
    cidr            = var.cidr
    azs             = var.azs
    public_subnets  = var.public_subnets
    private_subnets = var.private_subnets
}