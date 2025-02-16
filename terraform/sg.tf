resource "aws_security_group" "allow_tls" {
  name        = "group-5"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.group-5.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # needed for prometheus
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # needed for Grafana
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    # needs for ansible
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    # needs for node exporter
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}