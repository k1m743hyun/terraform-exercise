resource "aws_eip" "this" {
  vpc = true

  tags = merge(
    {
      Name = "eip-${var.tags.Environment}"
    },
    var.tags
  )
}