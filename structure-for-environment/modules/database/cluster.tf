# Aurora Postgres Global Cluster
resource "aws_rds_global_cluster" "this" {
  for_each                  = var.rds_value

  global_cluster_identifier = "${var.tags.Environment}-rds"
  engine                    = "aurora-postgresql"
  engine_version            = lookup(each.value, "engine_version", "13.3")
  storage_encrypted = true
}

# Aurora Postgres Cluster
resource "aws_rds_cluster" "this" {
  for_each                        = var.rds_value

  cluster_identifier              = format("${var.tags.Environment}-rds-%s", each.value.cluster_identifier)
  master_username                 = var.rds_master_username
  master_password                 = var.rds_master_password
  backup_retention_period         = 14
  db_subnet_group_name            = aws_db_subnet_group.this.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  vpc_security_group_ids          = [ aws_security_group.this.id ]
  engine                          = "aurora-postgresql"
  engine_version                  = lookup(each.value, "engine_version", "13.3")
  final_snapshot_identifier       = format("${var.tags.Environment}-snap-%s", each.value.cluster_identifier)
  skip_final_snapshot             = "true"
  global_cluster_identifier       = aws_rds_global_cluster.this[each.key].id
  enabled_cloudwatch_logs_exports = [ "postgresql" ]
  #kms_key_id                      = var.kms.rds
  storage_encrypted               = true
  apply_immediately               = each.value.apply_immediately
  deletion_protection             = lookup(each.value, "deletion_protection", true)
  snapshot_identifier             = each.value.snapshot_identifier

  depends_on = [
    aws_db_subnet_group.this,
    aws_rds_cluster_parameter_group.this,
    aws_security_group.this,
    aws_rds_global_cluster.this
  ]

  tags = merge(
    {
      Name    = format("${var.tags.Environment}-rds-%s", each.value.cluster_identifier)
      Type    = "rds"
      Purpose = each.key
    },
    var.tags
  )
}
