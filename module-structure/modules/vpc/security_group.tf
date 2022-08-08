# VPC 생성시 기본으로 생성되는 보안 그룹에 이름을 붙입니다
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "sg-${var.tags.Environment}-default"
    },
    var.tags
  )
}