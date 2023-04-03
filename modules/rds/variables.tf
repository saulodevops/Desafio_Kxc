variable "db_identifier" {
  type    = string
  description = "Nome da instancia RDS"
  default = "dbinstance"
}

variable "db_engine" {
  type    = string
  description = "Engine da database"
  default = "postgres"
}

variable "db_instance_class" {
  type    = string
  description = "Instance class da database"
  default = "db.t3.micro"
}

variable "db_database" {
  type    = string
  description = "Nome da database"
  default = "mydb"
}

variable "db_user" {
  type    = string
  description = "Username da database"
  default = "postgres"
}

variable "db_password" {
  type    = string
  description = "Password da database"
  default = "mypasswordj4n3r0"
}

variable "db_port" {
  type    = number
  description = "Porta que a database da aplicacao vai escutar"
  default = "5432"
}

variable "private_subnet_1_id" {
  description = "List of subnets in which to place the NAT Gateway"
}

variable "private_subnet_2_id" {
  description = "List of subnets in which to place the NAT Gateway"
}

variable "vpc_id" {
  
}