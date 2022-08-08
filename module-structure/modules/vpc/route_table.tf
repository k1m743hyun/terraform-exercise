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

# 퍼플릭 서브넷에 적용할 라우팅 테이블
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  
  tags = merge(
    {
      Name = "rtb-${var.tags.Environment}-public"
    },
    var.tags
  )
}

# 퍼플릭 서브넷에서 인터넷에 트래픽 요청시 앞서 정의한 인터넷 게이트웨이로 보냅니다
resource "aws_route" "public_worldwide" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# 프라이빗 서브넷에 적용할 라우팅 테이블
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  
  tags = merge(
    {
      Name = "rtb-${var.tags.Environment}-private"
    },
    var.tags
  )
}

# 프라이빗 서브넷에서 인터넷에 트래픽 요청시 앞서 정의한 NAT 게이트웨이로 보냅니다
resource "aws_route" "private_worldwide" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}