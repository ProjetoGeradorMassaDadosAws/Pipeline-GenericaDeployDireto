resource "aws_s3_bucket" "pipeline_sqs_geracao_arquivo_bucket" {
    bucket = var.BucketName
    tags   = {
       Nome = "pipeline"
  }
}

resource "aws_s3_bucket_acl" "pipeline_sqs_geracao_arquivo_bucket_acl" {
  bucket = aws_s3_bucket.pipeline_sqs_geracao_arquivo_bucket.id
  acl = "private"
}