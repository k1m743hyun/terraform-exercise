# Security Group
resource "aws_security_group" "rds_sg" {
  name = "seg-rds-${var.tags.Environment}"

  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "seg-rds-${var.tags.Environment}"
      Type = "sg"
    },
    var.tags
  )
}

# Security Group Rule
resource "aws_security_group_rule" "rds_sg_cidr" {
  for_each          = var.rds_sg_cidr
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_blocks]
  security_group_id = aws_security_group.rds_sg.id
  description       = each.value.description

  depends_on = [
    aws_security_group.rds_sg
  ]
}

resource "aws_security_group_rule" "rds_sg_source" {
  for_each                 = var.rds_sg_source
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  source_security_group_id = each.value.source
  security_group_id        = aws_security_group.rds_sg.id
  description              = each.value.description

  depends_on = [
    aws_security_group.rds_sg
  ]
}