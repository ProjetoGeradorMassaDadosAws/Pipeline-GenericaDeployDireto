data "aws_iam_role" "role_codebuild" {
  name = "codebuild_role"
}
resource "aws_codebuild_project" "codebuild" {
    name          = var.CodebuildName
    build_timeout = var.BuildTimeOut
    service_role  = data.aws_iam_role.role_codebuild.arn

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
        value = var.AWS_ACCESS_KEY_ID
      }

      environment_variable {
        name  = "AWS_SECRET_ACCESS_KEY"
        value = var.AWS_SECRET_ACCESS_KEY
      }

      environment_variable {
        name  = "AWS_REGION"
        value = var.AWS_SECRET_ACCESS_KEY
      }

    }

    logs_config {
        cloudwatch_logs {
            group_name  = "log-group"
            stream_name = "log-stream"
        }

        s3_logs {
            status   = "ENABLED"
            location = "${aws_s3_bucket.pipeline_bucket.id}/build-log"
        }
    }

    source {
        type            = "CODEPIPELINE"
        buildspec       = "buildspec.yaml"
    }

  source_version = "main"
}
