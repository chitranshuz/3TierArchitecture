#ec2 instance
resource "aws_instance" "web" {
  ami           = "<ami_id>"
  instance_type = "t3.micro"

  vpc_security_group_ids = aws_security_group.ec2.id
  key_name = aws_key_pair.ssh_key

  subnet_id  = var.public_subnet
  tags = {
    Name = "public_ec2"
  }
}

resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.web.id
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_instance" "web_private" {
  ami           = "<ami_id>"
  instance_type = "t3.micro"

  vpc_security_group_ids = aws_security_group.ec2.id
  key_name = aws_key_pair.ssh_key

  subnet_id  = var.private_subnet
  tags = {
    Name = "private_ec2"
  }
}

resource "aws_security_group" "ec2" {
  name = var.security_group

  description = "EC2 security group"
  vpc_id      = var.vpc_name

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "MySQL"
    cidr_blocks = var.db_address
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Telnet"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

