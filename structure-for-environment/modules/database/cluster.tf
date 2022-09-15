# aurora postgres global cluster
resource "aws_rds_global_cluster" "this" {
  for_each                  = var.rds_value
  global_cluster_identifier = format("rds-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-%s", each.value.cluster_identifier)
  engine                    = "aurora-postgresql"
  engine_version            = lookup(each.value, "engine_version", "13.3")
  #source_db_cluster_identifier = aws_rds_cluster.this[each.key].arn
  storage_encrypted = true
}

# aurora postgres cluster
resource "aws_rds_cluster" "this" {
  for_each                        = var.rds_value
  cluster_identifier              = format("rds-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-%s-01", each.value.cluster_identifier)
  master_username                 = var.rds_master_username
  master_password                 = var.rds_master_password
  backup_retention_period         = 14
  db_subnet_group_name            = "sbng-${var.environment}-rds"
  db_cluster_parameter_group_name = lookup(each.value, "db_cluster_parameter_group_name", aws_rds_cluster_parameter_group.rds_cluster_parmetg.name)
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  engine                          = "aurora-postgresql"
  engine_version                  = lookup(each.value, "engine_version", "13.3")
  final_snapshot_identifier       = format("snap-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-%s-01", each.value.cluster_identifier)
  skip_final_snapshot             = "true"
  global_cluster_identifier       = aws_rds_global_cluster.this[each.key].id
  enabled_cloudwatch_logs_exports = ["postgresql"]
  kms_key_id                      = var.kms.rds
  storage_encrypted               = true
  apply_immediately               = each.value.apply_immediately
  deletion_protection             = lookup(each.value, "deletion_protection", true)

  snapshot_identifier = each.value.snapshot_identifier

  tags = merge(
    {
      Name    = format("rds-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-%s-01", each.value.cluster_identifier)
      Type    = "rds"
      Purpose = each.key
    },
    var.tags
  )
}
