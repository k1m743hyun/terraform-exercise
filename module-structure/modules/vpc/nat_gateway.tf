# 프라이빗 서브넷에서 인터넷 접속시 사용할 NAT 게이트웨이
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public[0].id # NAT 게이트웨이 자체는 퍼플릭 서브넷에 위치해야 합니다
  
  tags = merge(
    {
      Name = "nat-${var.tags.Environment}-natgw"
    },
    var.tags
  )
}