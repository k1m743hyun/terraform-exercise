# ECR
resource "aws_ecr_repository" "this" {
  for_each             = var.ecr_value

  name                 = each.value.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    var.tags,
    {
      Name = format("${var.tags.Environment}-ecr-%s", each.value.name)
      Type = "ecr"
    }
  )
}

resource "aws_ecr_repository_policy" "this" {
  for_each   = var.ecr_value

  repository = aws_ecr_repository.this[each.key].name

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "ECR Policy",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::854013278161:root"
          ]
        },
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF

  depends_on = [
    aws_ecr_repository.this
  ]
}