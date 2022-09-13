# Subnet 생성
resource "aws_subnet" "this" {
  for_each = var.subnets
  
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value[index(var.subnets, each.value)]
  #availability_zone = var.azs[count.index]
  
  tags = merge(
    {
      Name = "sbn-${var.tags.Environment}-${each.value}-${index(var.subnets, each.value) + 1}"
    },
    var.tags
  )
}

# 프라이빗 서브넷을 라우팅 테이블에 연결합니다
#resource "aws_route_table_association" "private" {
#  for_each = var.subnets

#  count = length(each.value)

#  subnet_id      = aws_subnet.this[count.index].id
#  route_table_id = aws_route_table.this.id
#}