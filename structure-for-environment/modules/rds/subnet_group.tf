# RDS Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.tags.Environment}-sbng-rds"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name = "${var.tags.Environment}-sbng-rds"
      Type = "sbng"
    },
    var.tags
  )
}