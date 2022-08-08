# VPC 생성
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  
  tags = merge(
    {
      Name = "vpc-${var.tags.Environment}"
    },
    var.tags
  )
}