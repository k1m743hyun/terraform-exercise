# Subnet 생성
resource "aws_subnet" "this" {
  subnet_cidr = flatten([ for k, v in var.subnets : [ for c in v : join("-", [k, c]) ] ])
  count = length(subnet_cidr)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(split("-", subnet_cidr[count.index]), 1)
  #availability_zone = var.azs[count.index]
  
  tags = merge(
    {
      Name = "sbn-${var.tags.Environment}-${element(split("-", subnet_cidr[count.index]), 0)}-${count.index + 1}"
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