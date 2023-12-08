provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "metabase_cluster" {
  name = "metabase-cluster"
}

resource "aws_security_group" "metabase_sg" {
  name        = "metabase-sg"
  description = "Security group for Metabase"
  vpc_id      = "vpc-0d2884856a7131b15"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "metabase_task" {
  family                   = "metabase-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  desired_count            = 2
  container_definitions = <<DEFINITION
  [
    {
      "name": "metabase-container",
      "image": "metabase/metabase:latest",
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "environment": [
        {
          "name": "DATABASE_URL",
          "value": "metabase.csrlw3zxsyhl.us-east-1.rds.amazonaws.com" 
        },
        {
          "name": "MB_DB_TYPE",
          "value": "mysql" 
        },
        {
          "name": "MB_DB_DBNAME",
          "value": "metabase" 
        },
        {
          "name": "MB_DB_PORT",
          "value": "3306" 
        },
        {
          "name": "MB_DB_USER",
          "value": "db_metabase" 
        },
        {
          "name": "MB_DB_PASS",
          "value": "Dasg5sg4sdfw" 
        },
        {
          "name": "MB_DB_HOST",
          "value": "10.0.2.186" 
        }
      ]
    }
  ]
  DEFINITION
}
