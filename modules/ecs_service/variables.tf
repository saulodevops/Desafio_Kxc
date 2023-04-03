variable "cluster_name" {
  type    = string
  description = "Nome do cluster ECS"
  default = "cluster-api-kxc"
}

variable "task_family" {
  type    = string
  description = "Nome da familia da task do ECS"
  default = "service"
}

variable "app_name" {
  description = "Nome da aplicacao"
  type        = string
  default = "kxc-api"
}

variable "app_image" {
  description = "Imagem Docker que o Container vai utilizar"
  type        = string
  default = "063435536130.dkr.ecr.us-east-1.amazonaws.com/kxc-api:latest"
}

variable "service_name" {
  description = "Nome do service"
  type        = string
  default = "kxc-api-service"
}

variable "desired_count" {
  description = "Numero de instancias que a task definition vai manter rodando"
  type        = string
  default = "2"
}

variable "rds_instance_address" {
  
}

variable "private_subnet_1_id" {
  description = "List of subnets in which to place the NAT Gateway"
}

variable "private_subnet_2_id" {
  description = "List of subnets in which to place the NAT Gateway"
}

variable "vpc_id" {
}

variable "load_balancer_sg_id" {

}

variable "target_group_arn" {

}

variable "aws_lb_listener" {
  
}