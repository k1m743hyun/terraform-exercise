resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id

  for_each   = var.subnets
  cidr_block = each.value.cidr_block

  tags = merge(
    {
      Name = format(
        "sbn-${var.tags.Environment}-%s",
        each.value.name
      )
    },
    var.tags
  )
}

# 퍼플릭 서브넷을 정의합니다
resource "aws_subnet" "public" {
  count = length(local.public_subnets) # 여러 개를 정의합니다
  
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true # 퍼플릭 서브넷에 배치되는 서비스는 자동으로 공개 IP를 부여합니다
  
  tags = merge(
    {
      Name = "sbn-${var.tags.Environment}-public-${count.index + 1}"
    },
    var.tags
  )
}

# 퍼플릭 서브넷을 라우팅 테이블에 연결합니다
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 프라이빗 서브넷을 정의합니다
resource "aws_subnet" "private" {
  count = length(var.private_subnets) # 여러개를 정의합니다
  
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  
  tags = merge(
    {
      Name = "sbn-${var.tags.Environment}-private-${count.index + 1}"
    },
    var.tags
  )
}

# 프라이빗 서브넷을 라우팅 테이블에 연결합니다
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}