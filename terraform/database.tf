provider "aws" {
  region = "us-east-1"
}

resource "aws_db_subnet_group" "rds_db_subnet_group" {
  name       = "rds-db-subnet-group"
  subnet_ids = ["db_subnet_1", "app_subnet_1"]
  tags = {
    Name = "RDSDBSubnetGroup"
  }
}

resource "aws_security_group" "rds_db_security_group" {
  name        = "rds-db-security-group"
  description = "Security group for RDS DB"
  vpc_id      = "default"

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

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.small"
  identifier           = "metabase-db"
  username             = "db_metabase"
  password             = "Dasg5sg4sdfw"
  parameter_group_name = "default.postgres13"

  db_subnet_group_name     = aws_db_subnet_group.rds_db_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.rds_db_security_group.id]
}
