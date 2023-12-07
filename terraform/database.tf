provider "aws" {
  region = "us-east-1"
}

resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "aurora-db-subnet-group"
  subnet_ids = ["db_subnet_1", "app_subnet_1"]
  tags = {
    Name = "AuroraDBSubnetGroup"
  }
}

resource "aws_security_group" "aurora_db_security_group" {
  name        = "aurora-db-security-group"
  description = "Security group for Aurora DB"
  vpc_id      = "default"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AuroraDBSecurityGroup"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier        = "cluster-aurora"
  engine                    = "aurora"
  engine_version            = "5.7.mysql_aurora.2.07.2"
  database_name             = "metabase_db"
  master_username           = "db_metabase"
  master_password           = "Dasg5sg4sdfw"
  backup_retention_period   = 7
  preferred_backup_window   = "07:00-09:00"
  skip_final_snapshot       = true
  db_subnet_group_name      = aws_db_subnet_group.aurora_db_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.aurora_db_security_group.id]
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                   = 2
  cluster_identifier      = aws_rds_cluster.aurora_cluster.id
  instance_class          = "db.r5.large"
  engine                  = "aurora"
  engine_version          = "5.7.mysql_aurora.2.07.2"
  identifier              = "aurora-instance-${count.index}"
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.aurora_db_subnet_group.name
}
