# Aurora Postgres Instance 생성
resource "aws_rds_cluster_instance" "this" {
  for_each                     = { for k, v in var.rds_value : join("-", [k, lookup(v, "multi_az", [])]) => v }
  identifier                   = format("rdsinst-${var.tags.Environment}-%s-01-${element(split("-", each.key), 1)}", each.value.cluster_identifier)
  cluster_identifier           = aws_rds_cluster.this[element(split("-", each.key), 0)].cluster_identifier
  db_parameter_group_name      = aws_db_parameter_group.rds_instance_parmetg.name
  instance_class               = each.value.instance_class
  engine                       = "aurora-postgresql"
  engine_version               = lookup(each.value, "engine_version", "13.3")
  availability_zone            = "ap-northeast-2${substr(element(split("-", each.key), 1), -1, -1)}"
  performance_insights_enabled = true
  apply_immediately            = each.value.apply_immediately
  auto_minor_version_upgrade   = false
  monitoring_role_arn          = lookup(each.value, "monitoring_role_arn", null)
  monitoring_interval          = lookup(each.value, "monitoring_interval", null)

  tags = merge(
    {
      Name    = format("rdsinst-${var.tags.Environment}-%s-01-${element(split("-", each.key), 1)}", each.value.cluster_identifier)
      Type    = "rdsinst"
      Purpose = "postgres"
    },
    var.tags
  )
}