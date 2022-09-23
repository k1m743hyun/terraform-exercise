# Node Group
resource "aws_eks_node_group" "this" {
  for_each        = var.ngroup_value

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = format("${var.tags.Environment}-ng-%s-wrk", each.value.name)
  node_role_arn   = aws_iam_role.eks_ngroup_role.arn

  subnet_ids = var.subnet_ids

  launch_template {
    name    = aws_launch_template.this[each.key].name
    version = aws_launch_template.this[each.key].default_version
  }

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  labels = {
    lifecycle = "OnDemand"
  }

  depends_on = [
    aws_launch_template.this,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy,
    aws_iam_role_policy_attachment.AmazonEC2RoleforSSM,
    aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore,
  ]

  tags = merge(
    var.tags,
    {
      Name = format("${var.tags.Environment}-ng-%s-wrk", each.value.name)
      Type = "ng"
    }
  )

  # lifecycle {
  #   ignore_changes = [
  #     scaling_config[0].desired_size
  #   ]
  # }
}