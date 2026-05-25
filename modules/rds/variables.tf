variable "vpc_id" {
}
variable "vpc_subnet_ids" {
    type = list(string)
}
variable "db_engine" {
  default = "postgres"
}
variable "db_engine_version" {
  type = string
  default = "18.4"
}
variable "db_engine_class" {
  default = "db.t3.micro" 
}
variable "db_engine_storage" {
  type = number
  default = 20
}
variable "db_name" {
  default = "task_management"
}
variable "db_username" {
  default = "postgres"
}
variable "db_password" {
  sensitive   = true
}

variable "rds_sg_ids" {
    type = list(string)
}