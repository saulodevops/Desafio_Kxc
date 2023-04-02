module "rds" {
  source = "../rds"
}

# Cria as module.rdsiáveis de ambiente na AWS Parameter Store

resource "aws_ssm_parameter" "API_PORT" {
  name        = "/myapp/API_PORT"
  description = "Porta da API Node"
  type        = "String"
  value       = 3000
}

resource "aws_ssm_parameter" "DB_DATABASE" {
  name        = "/myapp/DB_DATABASE"
  description = "Database do banco de dados"
  type        = "String"
  value       = module.rds.DB_DATABASE
  depends_on  = [module.rds]  
}

resource "aws_ssm_parameter" "DB_HOST" {
  name        = "/myapp/DB_HOST"
  description = "Endereço do banco de dados"
  type        = "String"
  value       = module.rds.rds_instance_address
  depends_on  = [module.rds] 
}

resource "aws_ssm_parameter" "DB_PORT" {
  name        = "/myapp/DB_PORT"
  description = "Porta do banco de dados"
  type        = "String"
  value       = 5432
}

resource "aws_ssm_parameter" "DB_USER" {
  name        = "/myapp/DB_USER"
  description = "Usuário do banco de dados"
  type        = "String"
  value       = module.rds.DB_USER
  depends_on  = [module.rds] 
}

# resource "aws_ssm_parameter" "DB_PASSWORD" {
#   name        = "/myapp/DB_PASSWORD"
#   description = "Senha do banco de dados"
#   type        = "SecureString"
#   value       = module.rds.DB_PASSWORD
# }

# output "API_PORT" {
#   value = aws_ssm_parameter.API_PORT.value
# }

# output "DB_DATABASE" {
#   value = aws_ssm_parameter.DB_DATABASE.value
# }

# output "DB_HOST" {
#   value = aws_ssm_parameter.DB_HOST.value
# }

# output "DB_PORT" {
#   value = aws_ssm_parameter.DB_PORT.value
# }

# output "DB_USER" {
#   value = aws_ssm_parameter.DB_USER.value
# }

# output "DB_PASSWORD" {
#   value = aws_ssm_parameter.DB_PASSWORD.value
# }

# module "rds" {
#   source = "../rds"
# }