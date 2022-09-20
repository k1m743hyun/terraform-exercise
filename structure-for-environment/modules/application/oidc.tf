data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = [ "sts.amazonaws.com" ]
  thumbprint_list = [ data.tls_certificate.this.certificates[0].sha1_fingerprint ]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "this" {
  for_each = var.eks_oidc
  statement {
    actions = [ "sts:AssumeRoleWithWebIdentity" ]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${each.value.namespace}:${each.value.service}"
      ]
    }

    principals {
      identifiers = [ aws_iam_openid_connect_provider.this.arn ]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "this" {
  for_each           = var.eks_oidc
  assume_role_policy = data.aws_iam_policy_document.this[each.key].json
  name               = "role-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-eks-oidc-${each.key}"
}

resource "aws_iam_policy" "this" {
  for_each = { for k, v in var.eks_oidc : k => v if lookup(v, "policy", {}) != {} }
  name     = "policy-${var.tags.Owner}-${var.tags.Project}-${var.tags.Environment}-eks-oidc-${each.key}"
  path     = "/"

  policy = each.value.policy
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = { for k, v in var.eks_oidc : k => v if lookup(v, "policy", {}) != {} }
  policy_arn = aws_iam_policy.this[each.key].arn
  role       = aws_iam_role.this[each.key].name
}