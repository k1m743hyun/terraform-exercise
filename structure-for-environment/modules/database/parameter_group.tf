# Aurora Postgres 13 Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "rds_cluster_parmetg" {
  name   = "parmetg-${var.tags.Environment}-rds-cluster"
  family = "aurora-postgresql13"

  parameter {
    apply_method = "immediate"
    name         = "timezone"
    value        = "Asia/Seoul"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "rds.logical_replication"
    value        = "1"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements,pg_hint_plan,pglogical"
  }
  parameter {
    apply_method = "immediate"
    name         = "wal_sender_timeout"
    value        = "0"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "max_wal_senders"
    value        = "100"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "max_replication_slots"
    value        = "100"
  }
  parameter {
    apply_method = "immediate"
    name         = "synchronous_commit"
    value        = "off"
  }
  parameter {
    apply_method = "immediate"
    name         = "random_page_cost"
    value        = "1"
  }

  tags = merge(
    {
      Name = "parmetg-${var.tags.Environment}-rds-cluster"
      Type = "parmetg"
    },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      parameter
    ]
  }
}

# Aurora Postgres 13 Instance Parameter Group
resource "aws_db_parameter_group" "rds_instance_parmetg" {
  name   = "parmetg-${var.tags.Environment}-rds-instance"
  family = "aurora-postgresql13"

  parameter {
    name  = "log_statement"
    value = "all"
  }
  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }
  parameter {
    apply_method = "immediate"
    name         = "pg_hint_plan.debug_print"
    value        = "off"
  }
  parameter {
    apply_method = "immediate"
    name         = "pg_hint_plan.enable_hint"
    value        = "1"
  }
  parameter {
    apply_method = "immediate"
    name         = "pg_hint_plan.message_level"
    value        = "info"
  }
  parameter {
    apply_method = "immediate"
    name         = "log_min_messages"
    value        = "debug1"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements,pg_hint_plan,pgaudit"
  }
  parameter {
    apply_method = "immediate"
    name         = "random_page_cost"
    value        = "1"
  }
  parameter {
    apply_method = "immediate"
    name         = "log_replication_commands"
    value        = "1"
  }
  parameter {
    apply_method = "immediate"
    name         = "max_slot_wal_keep_size"
    value        = "2147483646"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "pglogical.synchronous_commit"
    value        = "0"
  }

  tags = merge(
    {
      Name = "parmetg-${var.tags.Environment}-rds-instance"
      Type = "parmetg"
    },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      parameter
    ]
  }
}