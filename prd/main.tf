terraform {
    required_providers {
        aws = {
            source    = "hashicorp/aws"
            version   = "~> 3.0"
        }
    }
}

provider "aws" {
    region = var.region
}

resource "aws_vpc" "AILab-vpc" {
    cidr_block = "172.31.0.0/16"

    tags = {
        Name = "AILab-vpc-prd"
    }
}

resource "aws_subnet" "main" {
    vpc_id      = aws_vpc.main.id
    cidr_block  = "172.31.0.0/24"
}
