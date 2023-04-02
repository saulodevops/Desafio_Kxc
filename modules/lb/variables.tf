variable "vpc_id" {
  description = "VPC id to place subnet into"
}

variable "private_subnet_1_id" {
  description = "List of subnets in which to place the NAT Gateway"
}

variable "private_subnet_2_id" {
  description = "List of subnets in which to place the NAT Gateway"
}