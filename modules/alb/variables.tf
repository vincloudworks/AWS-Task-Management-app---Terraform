variable "alb_type" {
  description = "The type of the Application Load Balancer (ALB)."
  type        = string
  default     = "application"
}

variable "alb_name" {
  description = "The name of the Application Load Balancer (ALB)."
  type        = string
  default     = "my-alb"
}
variable "alb_subnets" {
  description = "A list of subnet IDs to attach to the ALB."
  type        = list(string)

}

variable "alb_security_groups" {
  description = "A list of security group IDs to associate with the ALB."
  type        = list(string)
}

variable "alb_tags" {
  description = "A map of tags to assign to the ALB."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be created."
  type        = string
}

