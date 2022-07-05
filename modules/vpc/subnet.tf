resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id

  for_each   = var.subnets
  cidr_block = each.value.cidr_block

  tags = merge(
    {
      Name = "sbn-${var.tags.Environment}"
    },
    var.tags
  )
}
