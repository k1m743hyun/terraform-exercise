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
    cidr_block = "172.10.0.0/16"

    tags = {
        Name = "AILab-vpc-dev"
    }
}

resource "aws_subnet" "AILab-subnet-dev-0" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.0.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags = {
        Name = "AILab-subnet-dev-0"
    }
}

resource "aws_subnet" "AILab-subnet-dev-1" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.1.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"

    tags = {
        Name = "AILab-subnet-dev-1"
    }
}

resource "aws_subnet" "AILab-subnet-dev-2" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.2.0/24"
    availability_zone = "${data.aws_availability_zones.available.names[2]}"

    tags = {
        Name = "AILab-subnet-dev-2"
    }
}
