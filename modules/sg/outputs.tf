output "ec2_sg_id" {
    value = aws_security_group.ec2-SG1.id
}

output "rds_sg_id" {
    value = aws_security_group.rds-SG1.id
}

output "alb_sg_id" {
    value = aws_security_group.alb_sg.id
}

output "basion_sg_id" {
    value = aws_security_group.basion_sg.id
}