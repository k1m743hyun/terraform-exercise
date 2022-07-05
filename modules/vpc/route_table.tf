resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  for_each = var.route_table

  tags = merge(
    {
      Name = "rt-${var.tags.Environment}-${each.value.name}"
    },
    var.tags
  )
}

resource "aws_route_table_association" "this" {
  for_each = var.subnets

  subnet_id = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.this[each.value.route_table].id
}