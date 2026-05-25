resource "aws_security_group" "ec2-SG1" {
  vpc_id = var.vpc_id
  name        = "ec2-SG1"
  description = "Security group for EC2 instances"
  
  tags = {
    Name = "ec2-SG1"
    project = "WeekendProject"
  }

}

resource "aws_security_group" "rds-SG1" {
  vpc_id = var.vpc_id
  name        = "rds-SG1"
  description = "Security group for RDS instances"
  
  tags = {
    Name = "rds-SG1"
    project = "WeekendProject"
  }

}

resource "aws_security_group_rule" "allow_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds-SG1.id
  source_security_group_id = aws_security_group.ec2-SG1.id

}
resource "aws_security_group_rule" "allow_postgres" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds-SG1.id
  source_security_group_id = aws_security_group.ec2-SG1.id
}

resource "aws_security_group_rule" "allow_postgres1" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds-SG1.id
  source_security_group_id = aws_security_group.basion_sg.id
}


resource "aws_security_group_rule" "allow_outbound" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ec2-SG1.id
  cidr_blocks              = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "allow_app_port" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2-SG1.id
  source_security_group_id = aws_security_group.alb_sg.id
}


resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  name        = "alb-sg"
  description = "Security group for ALB"
  
  tags = {
    Name = "alb-sg"
    project = "WeekendProject"
  }
}


resource "aws_security_group_rule" "allow_alb_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
  
  }

resource "aws_security_group_rule" "allow_alb_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_outbound_alb" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.alb_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}


resource "aws_security_group" "basion_sg" {
  vpc_id = var.vpc_id
  name        = "basion-sg"
  description = "Security group for bastion host"
  
  tags = {
    Name = "basion-sg"
    project = "WeekendProject"
  }

}

resource "aws_security_group_rule" "allow_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.basion_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_bastion" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.basion_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_outboundforbastion" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.basion_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}