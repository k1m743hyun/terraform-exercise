resource "aws_nat_gateway" "this" {
  for_each = aws_subnet.this

  allocation_id = aws_eip.this.id
  subnet_id     = each.value.id

  tags = merge(
    {
      Name = "nat-${var.tags.Environment}"
    },
    var.tags
  )
}