/**data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    filter { 
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }

}**/

/**resource "aws_instance" "ec2_instance" {
    ami = data.aws_ami.latest_amazon_linux.id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.public_subnet_1_id
    vpc_security_group_ids = var.ec2_sg_ids
    associate_public_ip_address = true

    tags = {
        Name = "MyEC2Instance"
        project = "WeekendProject"
    }
} **/

resource "aws_iam_role" "ec2_ssm_launch_template_role" {
  name = "ec2-ssm-launch-template-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach_launch_template" {
  role       = aws_iam_role.ec2_ssm_launch_template_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_launch_template_profile" {
  name = "ec2_launch_template_profile"
  role = aws_iam_role.ec2_ssm_launch_template_role.name
}


resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "ec2-launch-template-"
  image_id      = "ami-0fd0ec892c8d13fc2"
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data_base64
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_launch_template_profile.arn
  }
  network_interfaces {
    security_groups       = var.ec2_sg_ids
    associate_public_ip_address = false
  }
  
  block_device_mappings {
    device_name = "/dev/xvda" # Root device name varies by AMI (e.g., /dev/xvda)

    ebs {
      volume_size = 8
      volume_type = "gp3" # Recommended general-purpose SSD
    }
  }  

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MyEC2Instance"
      project = "WeekendProject"
    }
  }
}

resource "aws_autoscaling_policy" "CPU_scale_up_policy" {
  name                   = "CPU_scale-up-policy"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  estimated_instance_warmup = 60
}


resource "aws_autoscaling_group" "my_asg" {
    desired_capacity     = 1
    max_size             = 2
    min_size             = 1
    launch_template {
        id      = aws_launch_template.ec2_launch_template.id
        version = "$Latest"
    }
    vpc_zone_identifier = var.private_subnet_ids
    target_group_arns = [var.target_group_arns[0]]

    health_check_type         = "ELB"
    health_check_grace_period = 60

    tag {
        key                 = "my_asg"
        value               = "MyAutoScalingEC2Instance"
        propagate_at_launch = true
    }
}

