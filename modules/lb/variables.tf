variable "vpc_id" {
  description = "VPC id to place subnet into"
}

variable "public_subnet_1_id" {
  description = "List of subnets in which to place the NAT Gateway"
}

variable "public_subnet_2_id" {
  description = "List of subnets in which to place the NAT Gateway"
}