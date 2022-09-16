# Aurora Postgres Instance 생성
resource "aws_rds_cluster_instance" "this" {
  for_each                     = var.rds_az
  identifier                   = format("rdsinst-${var.tags.Environment}-%s-01-${element(split("-", each.value), 1)}", var.rds_value[element(split("-", each.value), 0)].cluster_identifier)
  cluster_identifier           = aws_rds_cluster.this[element(split("-", each.value), 0)].cluster_identifier
  db_parameter_group_name      = aws_db_parameter_group.rds_instance_parmetg.name
  instance_class               = var.rds_value[element(split("-", each.value), 0)].instance_class
  engine                       = "aurora-postgresql"
  engine_version               = lookup(var.rds_value[element(split("-", each.value), 0)], "engine_version", "13.3")
  availability_zone            = "ap-northeast-2${substr(element(split("-", each.value), 1), -1, -1)}"
  performance_insights_enabled = true
  apply_immediately            = var.rds_value[element(split("-", each.value), 0)].apply_immediately
  auto_minor_version_upgrade   = false
  monitoring_role_arn          = lookup(var.rds_value[element(split("-", each.value), 0)], "monitoring_role_arn", null)
  monitoring_interval          = lookup(var.rds_value[element(split("-", each.value), 0)], "monitoring_interval", null)

  tags = merge(
    {
      Name    = format("rdsinst-${var.tags.Environment}-%s-01-${element(split("-", each.value), 1)}", var.rds_value[element(split("-", each.value), 0)].cluster_identifier)
      Type    = "rdsinst"
      Purpose = "postgres"
    },
    var.tags
  )
}