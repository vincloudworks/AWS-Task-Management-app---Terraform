variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  
}
variable "aws_region" {
  
}
variable "vpc_name" {
  default = "MyVPC"
}

variable "public_subnet_1_cidr" {
    default =  "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
    default =  "10.0.11.0/24"
}

variable "private_subnet_1_cidr" {
  default = "10.0.2.0/24"
}
variable "private_subnet_2_cidr" {
  default = "10.0.12.0/24"
}