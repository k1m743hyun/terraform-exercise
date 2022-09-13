# NAT 게이트웨이는 고정 IP를 필요로 합니다
resource "aws_eip" "this" {
  vpc = true
  
  tags = merge(
    {
      Name = "eip-${var.tags.Environment}-natgw"
    },
    var.tags
  )
}