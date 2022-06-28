provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-state"
    
    # 실수로 S3 버킷을 삭제하는 것을 방지
    lifecycle {
        prevent_destroy = true
    }

    # 서버 측 암호화를 활성화
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-locks"
    biling_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute = {
        name = "LockID"
        type = "S"
    }
}