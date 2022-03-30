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
