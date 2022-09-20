# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
  name = "role-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-eks-cluster"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_security_group" "eks_cluster_sg" {
  name   = "seg-eks-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-app"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "seg-eks-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-app"
  }
}

# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "eks-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-app"
  version  = "1.21"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids = [ aws_security_group.eks_cluster_sg.id ]
    subnet_ids = [
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs = [
    ]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]

  tags = merge(
    var.tags,
    {
      Name = "eks-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-app"
      Type = "eks"
    }
  )
}