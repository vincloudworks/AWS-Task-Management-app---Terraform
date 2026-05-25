data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


resource "aws_s3_bucket" "S3_backend" {
  bucket = format("weekendproject1-tf-state-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.region)


  tags = {
    Name        = "Terraform Weekend project State Storage"
    Environment = "Bootstrap"

  }

}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.S3_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

