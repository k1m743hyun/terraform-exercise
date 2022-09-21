# Security Group
resource "aws_security_group" "this" {
  name   = "sg-${var.tags.Environment}-rds"
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "sg-${var.tags.Environment}-rds"
      Type = "sg"
    },
    var.tags
  )
}

# Security Group Rule
resource "aws_security_group_rule" "this" {
  for_each          = var.sg_rds_cidr

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_blocks]
  security_group_id = aws_security_group.this.id
  description       = each.value.description

  depends_on = [
    aws_security_group.this
  ]
}

#resource "aws_security_group_rule" "sg_rds_source" {
#  for_each                 = var.sg_rds_source

#  type                     = each.value.type
#  from_port                = each.value.from_port
#  to_port                  = each.value.to_port
#  protocol                 = each.value.protocol
#  source_security_group_id = each.value.source
#  security_group_id        = aws_security_group.sg_rds.id
#  description              = each.value.description

#  depends_on = [
#    aws_security_group.sg_rds
#  ]
#}