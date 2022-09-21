# Public Subnet에 연결할 Internet gateway 생성
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  depends_on = [
    aws_vpc.this
  ]
  
  tags = merge(
    {
      Name = "igw-${var.tags.Environment}"
    },
    var.tags
  )
}