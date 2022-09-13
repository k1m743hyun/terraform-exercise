# VPC 생성시 기본으로 생성되는 라우트 테이블에 이름을 붙입니다
# 이걸 서브넷에 연결해 써도 되지만, 여기서는 사용하지 않습니다
resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  
  tags = merge(
    {
      Name = "rtb-${var.tags.Environment}-default"
    },
    var.tags
  )
}

# 서브넷에 적용할 라우팅 테이블 생성
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  
  for_each = var.route_tables

  tags = merge(
    {
      Name = "rtb-${var.tags.Environment}-${each.values}"
    },
    var.tags
  )
}

# 퍼플릭 서브넷에서 인터넷에 트래픽 요청시 앞서 정의한 인터넷 게이트웨이로 보냅니다
# 프라이빗 서브넷에서 인터넷에 트래픽 요청시 앞서 정의한 NAT 게이트웨이로 보냅니다
resource "aws_route" "this" {
  for_each = var.route_tables

  route_table_id         = aws_route_table[each.values].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = each.values == "public" ? aws_internet_gateway.this.id : ""
  nat_gateway_id         = each.values == "public" ? "" : aws_nat_gateway.this.id
}