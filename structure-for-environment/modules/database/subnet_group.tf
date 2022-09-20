# RDS Subnet Group
resource "aws_db_subnet_group" "rds_sbng" {
  name       = "sbng-${var.tags.Environment}-rds"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name = "sbng-${var.tags.Environment}-rds"
      Type = "sbng"
    },
    var.tags
  )
}