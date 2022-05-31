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
        Name = "AILab-vpc-prd"
    }
}

resource "aws_subnet" "AILab-subnet-prd-a" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.0.0/24"
    availability_zone = "${var.region}a"

    tags = {
        Name = "AILab-subnet-prd-a"
    }
}

resource "aws_subnet" "AILab-subnet-prd-c" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.2.0/24"
    availability_zone = "${var.region}c"

    tags = {
        Name = "AILab-subnet-prd-c"
    }
}

resource "aws_subnet" "AILab-subnet-prd-d" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.3.0/24"
    availability_zone = "${var.region}d"

    tags = {
        Name = "AILab-subnet-prd-d"
    }
}
