# VPC 생성시 기본으로 생성되는 라우트 테이블에 이름을 붙입니다
# 이걸 서브넷에 연결해 써도 되지만, 여기서는 사용하지 않습니다
resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    {
      Name = "rt-${var.tags.Environment}-default"
    },
    var.tags
  )
}


