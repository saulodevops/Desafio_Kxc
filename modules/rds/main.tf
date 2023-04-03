# Cria uma instância RDS micro, postgres, dentro das subnets privadas

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}


resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [var.private_subnet_1_id,var.private_subnet_2_id]
}

resource "aws_db_instance" "db_instance" {
  identifier           = var.db_identifier
  engine               = var.db_engine
  engine_version       = "13.3"
  instance_class       = var.db_instance_class
  name                 = var.db_database
  username             = var.db_user
  password             = var.db_password
  allocated_storage    = 20
  storage_type         = "gp2"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot = true
}

output "rds_instance_address" {
  description = "ARN da instancia RDS"
  value = aws_db_instance.db_instance.address
}

output "DB_DATABASE" {
  value = aws_db_instance.db_instance.name
}

output "db_port" {
  value = "5432"
}

output "DB_USER" {
  value = aws_db_instance.db_instance.username
}
