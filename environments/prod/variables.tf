variable "aws_region" {
  
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "db_password" {

}

variable "db_name" {
  
}
variable "db_username" {
}

variable "instance_type" {
    default = "t3.micro"
  
}

variable "key_name" {
    default = "myEC2"
}

variable "ec2_sg_ids" {
    type = list(string)
    default = []
}


variable "vpc_id" {
default = "vpc-0a1b2c3d4e5f6g7h"
}

