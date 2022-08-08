# 퍼플릭 서브넷에 연결할 인터넷 게이트웨이를 정의합니다
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "igw-${var.tags.Environment}"
    },
    var.tags
  )
}