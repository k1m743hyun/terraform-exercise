locals {
  http_port    = 12345
  any_port     = 0
  tcp_protocol = "tcp"
  any_protocol = "-1"
  all_ips      = ["0.0.0.0/0"]
}

module "webserver_cluster" {
  source        = "../modules/services/webserver-cluster"

  cluster_name  = var.cluster_name

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}