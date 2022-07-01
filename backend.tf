terraform {
  backend "s3" {
    # 이전에 생성한 버킷 이름으로 변경
    bucket          = "terraform-state"
    key             = "global/s3/terraform.tfstate"
    region          = "us-east-2"

    # 이전에 생성한 다이나모DB 테이블 이름으로 변경
    dynamodb_tablee = "terraform-locks"
    encrypt         = true
  }
} 
