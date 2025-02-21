data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "deployer" {
  key_name   = "bastion"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.deployer.key_name
  instance_type = var.instance_type
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  
  user_data = file("prometheus.sh")
  
  tags = {
    Name = "group-5"
  }
}

output ec2 {
    value = aws_instance.web.public_ip
}

