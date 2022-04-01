resource "aws_s3_bucket" "pipeline_bucket" {
    bucket = var.BucketName
    tags   = {
       Nome = "pipeline"
  }
}

resource "aws_s3_bucket_acl" "pipeline_bucket_acl" {
  bucket = aws_s3_bucket.pipeline_bucket.id
  acl = "private"
}