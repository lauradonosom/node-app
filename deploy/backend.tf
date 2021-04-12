terraform {
  backend "s3" {
    bucket = "terraform-state-231081081110"
    key    = "deploy.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}