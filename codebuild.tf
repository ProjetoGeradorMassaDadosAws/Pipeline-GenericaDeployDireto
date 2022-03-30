resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_role_policy" {
  name = "codebuild_role_policy"
  role = aws_iam_role.codebuild_role.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline_sqs_geracao_arquivo_bucket.arn}",
        "${aws_s3_bucket.pipeline_sqs_geracao_arquivo_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "codebuild_sqs_geracao_arquivo" {
    name          = "codebuild_sqs_geracao_arquivo"
    build_timeout = "60"
    service_role  = aws_iam_role.codebuild_role.arn

    artifacts {
        type = "CODEPIPELINE"
    }

    environment {
      compute_type                = "BUILD_GENERAL1_SMALL"
      image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
      type                        = "LINUX_CONTAINER"
      image_pull_credentials_type = "CODEBUILD"

      environment_variable {
        name  = "AWS_ACCESS_KEY_ID"
        value = "Seu Id"
      }

      environment_variable {
        name  = "AWS_SECRET_ACCESS_KEY"
        value = "Seu Secret"
      }

    }

    logs_config {
        cloudwatch_logs {
            group_name  = "log-group"
            stream_name = "log-stream"
        }

        s3_logs {
            status   = "ENABLED"
            location = "${aws_s3_bucket.pipeline_sqs_geracao_arquivo_bucket.id}/build-log"
        }
    }

    source {
        type            = "CODEPIPELINE"
        buildspec       = "buildspec.yaml"
    }

  source_version = "main"
}
