# Aurora Postgres Instance 생성
resource "aws_rds_cluster_instance" "this" {
  count                        = length(var.rds_az)
  
  identifier                   = format("${var.tags.Environment}-rdsinst-%s-${element(split("-", var.rds_az[count.index]), 1)}", var.rds_value[element(split("-", var.rds_az[count.index]), 0)].cluster_identifier)
  cluster_identifier           = aws_rds_cluster.this[element(split("-", var.rds_az[count.index]), 0)].cluster_identifier
  db_parameter_group_name      = aws_db_parameter_group.this.name
  instance_class               = var.rds_value[element(split("-", var.rds_az[count.index]), 0)].instance_class
  engine                       = "aurora-postgresql"
  engine_version               = lookup(var.rds_value[element(split("-", var.rds_az[count.index]), 0)], "engine_version", "13.3")
  availability_zone            = "${var.region}${substr(element(split("-", var.rds_az[count.index]), 1), -1, -1)}"
  performance_insights_enabled = true
  apply_immediately            = var.rds_value[element(split("-", var.rds_az[count.index]), 0)].apply_immediately
  auto_minor_version_upgrade   = false
  monitoring_role_arn          = lookup(var.rds_value[element(split("-", var.rds_az[count.index]), 0)], "monitoring_role_arn", null)
  monitoring_interval          = lookup(var.rds_value[element(split("-", var.rds_az[count.index]), 0)], "monitoring_interval", null)

  depends_on = [
    aws_rds_cluster.this,
    aws_db_parameter_group.this
  ]

  tags = merge(
    {
      Name    = format("${var.tags.Environment}-rdsinst-%s-${element(split("-", var.rds_az[count.index]), 1)}", var.rds_value[element(split("-", var.rds_az[count.index]), 0)].cluster_identifier)
      Type    = "rdsinst"
      Purpose = "postgres"
    },
    var.tags
  )
}