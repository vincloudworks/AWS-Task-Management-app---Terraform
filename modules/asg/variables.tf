variable "vpc_id" {}

variable "private_subnet_ids" {

    type = list(string)
}
variable "instance_type" {
    default = "t3.micro"
  
}
variable "key_name" {
    default = "myEC2"
}

variable "ec2_sg_ids" {
    type = list(string)
}

variable "target_group_arns" {
    type = list(string)
}

variable "user_data_base64" {
  type        = string
  description = "The base64 encoded user data script passed from the root"
  default     = null
}