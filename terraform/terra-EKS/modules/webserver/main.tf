
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
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = "server-key"

  tags = {
        Name : "jump-server"
    }
}
