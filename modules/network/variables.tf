variable "vpc_cidr_block" {
  type    = string
  description = "CIDR block da VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  description = "CIDR subnets publicas"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  description = "CIDR subnets privadas"
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}