#Definição do security group do load balancer 
resource "aws_security_group" "lb_sg" {
  name_prefix        = "lbsg-"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
}

# Definição do recurso aws_lb_listener para escutar na porta 80
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }
}

# Definição do recurso aws_lb_target_group
resource "aws_lb_target_group" "my_target_group" {
  name_prefix   = "my-tg-"
  port          = 3000
  protocol      = "HTTP"
  vpc_id        = var.vpc_id
  target_type   = "ip"
    
  health_check {
    healthy_threshold   = 2
    interval            = 30
    path                = "/"
    port                = 3000
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# Definição do recurso aws_lb
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

}

output "target_group_arn" {
  value = aws_lb_target_group.my_target_group.arn
}

output "load_balancer_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "aws_lb_listener" {
  value = aws_lb_listener.my_listener
}