resource "aws_default_security_group" "default-sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

data "aws_ami" "latest-aws-linux-image" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

output "aws_ami_id" {
  value = data.aws_ami.latest-aws-linux-image.id
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file("id_rsa.pub")
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-aws-linux-image.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = "server-key"

  user_data = file("entry-script.sh")

  tags = {
        Name : "${var.env_prefix}-server"
    }

    # provisioner "local-exec" {
    # working_dir = "C/root/Terraform-Ansible/Ansible:/Users/Bushra Fatima/Documents/Ansible"
    # command = "ansible-playbook --inventory ${self.public_ip}, --private-key ${var.ssh-key-private} --user ec2-user deploy-docker.yaml"
# }
}

resource "null_resource" "configure-server" {
  triggers = {
    trigger = aws_instance.myapp-server.public_ip
    #we van define a list of IPs here
  }
  provisioner "local-exec" {
    working_dir = "/root/Terraform-Ansible/Ansible"
    command = "ansible-playbook --inventory ${aws_instance.myapp-server.public_ip}, --private-key ${var.ssh-key-private} --user ec2-user deploy-docker.yaml"
}
}
