provider "aws" {
  region  = "sa-east-1"
  shared_credentials_file = "c:/Users/igorc/.aws/credentials"
  profile = "default"
}

resource "aws_codepipeline" "pipeline_sqs_geracao_arquivo" {
    name = var.PipelineName
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