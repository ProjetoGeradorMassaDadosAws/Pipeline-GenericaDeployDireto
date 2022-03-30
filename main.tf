provider "aws" {
  region  = "sa-east-1"
  shared_credentials_file = "c:/Users/igorc/.aws/credentials"
  profile = "default"
}

resource "aws_codepipeline" "pipeline_sqs_geracao_arquivo" {
    name = "pipeline_sqs_geracao_arquivo"
    role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
      location = aws_s3_bucket.pipeline_sqs_geracao_arquivo_bucket.bucket
      type = "S3"
    }

    stage {
        name = "Source"
      
      action {
            name     = "Source" 
            category = "Source"
            owner    = "AWS"
            provider = "CodeStarSourceConnection"
            version  = "1"
            output_artifacts = ["source_output"]
            
            configuration = {
                ConnectionArn    = aws_codestarconnections_connection.conexao_github.arn
                FullRepositoryId = var.FullRepositoryId
                BranchName       = var.BranchName
            }
        }
    }

    stage {
        name = "Deploy"

        action {
            name            = "Deploy"
            category        = "Build"
            owner           = "AWS"
            provider        = "CodeBuild"
            version         = "1"
            input_artifacts = ["source_output"]
           
            configuration = {
                ProjectName = aws_codebuild_project.codebuild_sqs_geracao_arquivo.name
            }
        }
    } 
}

resource "aws_iam_role" "codepipeline_role" {
    name               = "codepipeline_role"
    assume_role_policy =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF 
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
    name   = "codepipeline_role_policy"
    role   = aws_iam_role.codepipeline_role.id
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline_sqs_geracao_arquivo_bucket.arn}",
        "${aws_s3_bucket.pipeline_sqs_geracao_arquivo_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${aws_codestarconnections_connection.conexao_github.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action":[
            "cloudformation:DescribeStacks",
            "cloudformation:DescribeStackEvents",
            "cloudformation:DescribeStackResource",
            "cloudformation:DescribeStackResources"
        ],
      "Resource": "*"
    }
  ]
}
EOF
}