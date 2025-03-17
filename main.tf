terraform {
  backend "s3" {
    bucket = "nv-terraform-st-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}


resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-terraform-test"
}

