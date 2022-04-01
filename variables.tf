variable "FullRepositoryId" {
  type = string
  description = "Caminho do repositorio"
}

variable "BranchName" {
  type = string
  description = "Nome da branch"
}

variable "AWS_ACCESS_KEY_ID" {
  type = string
  description = "Id da chave AWS"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  description = "Segredo da chave AWS"
}

variable "AWS_REGION" {
  type = string
  description = "Regiao da Aws"
}

variable "PipelineName" {
  type = string
  description = "Nome da pipeline"
}

variable "CodebuildName" {
  type = string
  description = "Nome do projeto codebuild"
}

variable "BuildTimeOut" {
  type = string
  description = "Tempo maximo de duracao do build"
  default = "60"
}

variable "BucketName" {
  type = string
  description = "Nome do bucket"
}