terraform {
  backend "s3" {
    bucket = "nv-terraform-st-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-terraform-test"  # Replace with a globally unique name
  acl    = "private"  # Set to the desired ACL, e.g., "private", "public-read", etc.
  region = "us-east-1"  # Specify the region (optional, can be inferred from provider)
}