# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.tags.Environment}-eks-app"
  version  = "1.21"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids = [ aws_security_group.eks_cluster_sg.id ]
    subnet_ids = [ "" ]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs = [ "" ]
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
      Name = "${var.tags.Environment}-eks-app"
      Type = "eks"
    }
  )
}