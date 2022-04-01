provider "aws" {
  region  = "sa-east-1"
  shared_credentials_file = "c:/Users/igorc/.aws/credentials"
  profile = "default"
}

data "aws_iam_role" "role_pipeline" {
  name = "codepipeline_role"
}
resource "aws_codepipeline" "pipeline" {
    name = var.PipelineName
    role_arn = data.aws_iam_role.role_pipeline.arn

    artifact_store {
      location = aws_s3_bucket.pipeline_bucket.bucket
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
                ProjectName = aws_codebuild_project.codebuild.name
            }
        }
    } 
}