resource "aws_codestarconnections_connection" "conexao_github" {
  name                   = "conexao_github"
  provider_type          = "GitHub" 
}