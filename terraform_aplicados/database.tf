provider "aws" {
  region = "us-east-1"
}

resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name       = "rds-db-subnet-group"
  subnet_ids = [
    "subnet-043d10bb26ba99001",
    "subnet-009a144dd41e53f8b",
  ]

  tags = {
    Name = "RDSDBSubnetGroup"
  }
}

resource "aws_security_group" "rds_db_security_group" {
  name        = "rds-db-security-group"
  description = "Security group for RDS DB"
  vpc_id      = "vpc-0d2884856a7131b15"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDSDBSecurityGroup"
  }
}

resource "aws_db_instance" "metabase_db" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  identifier             = "metabase"
  username               = "db_metabase"
  password               = "Dasg5sg4sdfw"
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.rds_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_db_security_group.id]
}


