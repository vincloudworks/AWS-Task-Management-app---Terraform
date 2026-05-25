output "target_group_arns" {
    value = [aws_alb_target_group.my_alb_target_group.arn]
}

output "alb_dns_name" {
    value = aws_alb.my_alb.dns_name
}