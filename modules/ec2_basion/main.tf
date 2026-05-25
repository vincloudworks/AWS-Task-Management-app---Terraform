/**data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    filter { 
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }

}**/

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-role"
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

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "ec2_instance" {
   # ami = data.aws_ami.latest_amazon_linux.id
    ami = "ami-0fd0ec892c8d13fc2"
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.public_subnet_ids[0]
    vpc_security_group_ids = var.basion_sg_ids
    associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
        delete_on_termination = true
    }

    user_data_base64     = var.user_data_base64

    tags = {
        Name = "MyEC2Instance"
        project = "WeekendProject"
    }
}


