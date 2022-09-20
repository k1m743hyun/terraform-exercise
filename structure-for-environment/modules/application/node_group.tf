# Node Group Role
resource "aws_iam_role" "eks_ngroup_role" {
  name = "role-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-eks-ngroup"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_ngroup_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_ngroup_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_ngroup_role.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_ngroup_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.eks_ngroup_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_ngroup_role.name
}

# Node Group
resource "aws_eks_node_group" "this" {
  for_each        = var.ngroup_value
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = format("ngroup-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-%s-wrk", each.value.name)
  node_role_arn   = aws_iam_role.eks_ngroup_role.arn

  subnet_ids = [
  ]

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
      Name = format("ngroup-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-%s-wrk", each.value.name)
      Type = "ngroup"
    }
  )

  # lifecycle {
  #   ignore_changes = [
  #     scaling_config[0].desired_size
  #   ]
  # }
}