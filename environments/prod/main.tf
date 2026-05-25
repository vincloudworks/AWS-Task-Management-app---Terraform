module "vpc" {
    source = "../../modules/vpc"
    cidr_block = var.vpc_cidr
    vpc_name = "prod-vpc"
    aws_region = var.aws_region

  
}

module "ec2_basion" {
    depends_on = [module.vpc, module.sg, module.rds]
    source = "../../modules/ec2_basion"
    vpc_id = module.vpc.vpc_id
    instance_type = var.instance_type
    key_name = var.key_name
    public_subnet_ids = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
    basion_sg_ids = [module.sg.basion_sg_id]
    user_data_base64 = base64encode(templatefile("${path.module}/user_data.tftpl", {
    }))

}

module "alb" {
    depends_on = [module.vpc, module.sg]
    source = "../../modules/alb"
    alb_name = "prod-alb"
    alb_subnets = [module.vpc.public_subnet_1_id, module.vpc.public_subnet_2_id]
    alb_security_groups = [module.sg.alb_sg_id]
    vpc_id = module.vpc.vpc_id
}

module "asg"{
    depends_on = [module.vpc, module.sg]
    source = "../../modules/asg"
    vpc_id = module.vpc.vpc_id
    private_subnet_ids = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
    instance_type = var.instance_type
    key_name = var.key_name
    ec2_sg_ids = [module.sg.ec2_sg_id]
    target_group_arns = module.alb.target_group_arns
    user_data_base64 = base64encode(templatefile("${path.module}/user_data.tftpl", {
    }))
}

module "rds" {
    depends_on = [module.vpc, module.sg]
    source = "../../modules/rds"
    vpc_id = module.vpc.vpc_id
    vpc_subnet_ids = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    rds_sg_ids = [module.sg.rds_sg_id]
}

module "sg" {
    depends_on = [module.vpc]
    source = "../../modules/sg"
    vpc_id = module.vpc.vpc_id
}