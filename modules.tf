provider "aws" {
  profile = "sauloramos-kxc"
  region     = "us-east-1"
}

module "network" {
  source = "./modules/network"
}

module "lb" {
  source = "./modules/lb"
  vpc_id = module.network.vpc_id
  public_subnet_1_id = module.network.public_subnet_1_id
  public_subnet_2_id = module.network.public_subnet_2_id
}

module "rds" {
  source = "./modules/rds"
  private_subnet_1_id = module.network.private_subnet_1_id
  private_subnet_2_id = module.network.private_subnet_2_id
  vpc_id = module.network.vpc_id
}

# module "parameter_store" {
#   source = "./modules/parameter_store"
# }

module "ecs_service" {
  source = "./modules/ecs_service"
  rds_instance_address = module.rds.rds_instance_address
  # target_group_arn = module.lb.target_group_arn
  private_subnet_1_id = module.network.private_subnet_1_id
  private_subnet_2_id = module.network.private_subnet_2_id
  vpc_id = module.network.vpc_id
  load_balancer_sg_id = module.lb.load_balancer_sg_id
  target_group_arn = module.lb.target_group_arn
  aws_lb_listener = module.lb.aws_lb_listener
}