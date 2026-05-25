resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.vpc_subnet_ids

  tags = {
    Name = "rds-subnet-group"
    project = "weekend-project"
  }
}

resource "aws_db_instance" "myRDS" {
    identifier          = "my-rds-instance"
  allocated_storage    = var.db_engine_storage
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_engine_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = var.rds_sg_ids
  skip_final_snapshot   = true
  multi_az              = false
  publicly_accessible   = false

  tags = {
    Name = "myRDS"
    project = "weekend-project"
  }
}

resource "aws_ssm_parameter" "secret" {
  name        = "/production/myrds/database/password"
  description = "The parameter description"
  type        = "SecureString"
  value       = var.db_password

  tags = {
    environment = "production"
    project     = "weekend-project"
  }
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/production/myrds/database/username"
  description = "The parameter description"
  type        = "String"
  value       = var.db_username

  tags = {
    environment = "production"
    project     = "weekend-project"
  }
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/production/myrds/database/db_name"
  description = "Database name parameter"
  type        = "String"
  value       = var.db_name

  tags = {
    environment = "production"
    project     = "weekend-project"
  }
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/production/myrds/database/host"
  description = "DB host parameter"
  type        = "String"
  value       = aws_db_instance.myRDS.endpoint

  tags = {
    environment = "production"
    project     = "weekend-project"
  }
}