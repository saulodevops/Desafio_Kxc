# Definição do recurso aws_ecs_cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = var.cluster_name
}

# Definição do recurso aws_security_group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3000
    to_port   = 3000
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

# Definição do IAM role do ECS
resource "aws_iam_role" "ecs_execution" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Definição do IAM policy do ECS
resource "aws_iam_policy" "ecs_execution_policy" {
  name = "ecs_execution_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:Describe*",
          "rds:ListTagsForResource",
          "rds-db:connect",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Definição do attachment da role do ECS
resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
  role       = aws_iam_role.ecs_execution.name
}


# Definição do recurso aws_ecs_task_definition
resource "aws_ecs_task_definition" "my_task" {
  family = var.task_family

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.app_name}",
      "image": "${var.app_image}",
      "entryPoint": [],
      "environment": [
        {
          "name": "DB_USER",
          "value": "postgres"
        },
        {
          "name": "DB_PASSWORD",
          "value": "mypasswordj4n3r0"
        },
        {
          "name": "DB_PORT",
          "value": "5432"
        },
        {
          "name": "DB_HOST",
          "value": "${var.rds_instance_address}"
        },
        {
          "name": "DB_DATABASE",
          "value": "mydb"
        }
      ],
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
DEFINITION


  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = "arn:aws:iam::063435536130:role/ecsTaskExecutionRole"
  task_role_arn            = aws_iam_role.ecs_execution.arn

}


# Definição do recurso aws_ecs_service
resource "aws_ecs_service" "my_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.my_cluster.arn
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  scheduling_strategy  = "REPLICA"
  force_new_deployment = true

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.app_name
    container_port   = 3000
  }

  network_configuration {
    security_groups = [aws_security_group.ecs_sg.id, var.load_balancer_sg_id]
    subnets         = [var.private_subnet_1_id, var.private_subnet_2_id]
    assign_public_ip = false
  }

  depends_on = [
    aws_ecs_task_definition.my_task, var.aws_lb_listener
  ]
}