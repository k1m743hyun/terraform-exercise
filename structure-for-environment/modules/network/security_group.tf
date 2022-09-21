# VPC 생성 시 기본으로 생성되는 Security group에 이름을 붙입니다
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  depends_on = [
    aws_vpc.this
  ]
  
  tags = merge(
    {
      Name = "seg-${var.tags.Environment}-default"
      Type = "seg"
    },
    var.tags
  )
}