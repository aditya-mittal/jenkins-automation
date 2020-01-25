data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "jenkins_userdata" {
  template = file("userdata.sh.tpl")

  vars = {
    aws_region        = local.aws_region
    admin_password    = var.admin_password
    readonly_password = var.readonly_password
    image_tag         = local.jenkins_image_tag
  }
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public_us_east_1a.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins.name

  associate_public_ip_address = true

  user_data = data.template_file.jenkins_userdata.rendered

  root_block_device {
    volume_size           = 30
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    map(
      "Name", "${local.name_prefix}-jenkins"
    ),
    local.common_tags
  )
}