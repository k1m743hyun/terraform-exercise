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

resource "aws_subnet" "AILab-subnet-dev-a" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.0.0/24"
    availability_zone = "${var.region}a"

    tags = {
        Name = "AILab-subnet-dev-a"
    }
}

resource "aws_subnet" "AILab-subnet-dev-b" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.1.0/24"
    availability_zone = "${var.region}b"

    tags = {
        Name = "AILab-subnet-dev-b"
    }
}

resource "aws_subnet" "AILab-subnet-dev-c" {
    vpc_id      = aws_vpc.AILab-vpc.id
    cidr_block  = "172.10.2.0/24"
    availability_zone = "${var.region}c"

    tags = {
        Name = "AILab-subnet-dev-c"
    }
}
