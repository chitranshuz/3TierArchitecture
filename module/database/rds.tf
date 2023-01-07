resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [var.private_subnet, var.private_sub_t]

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_security_group" "allow_tcp" {
  name        = "allow_tcp"
  description = "Allow Tcp inbound traffic"
  vpc_id      = var.vpc_name
  ingress {
    description      = "Tcp"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = var.privateinstance_ip
  }

}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.username
  password             = var.password

  vpc_security_group_ids = aws_security_group.allow_tcp.id
  db_subnet_group_name = aws_db_subnet_group.default.name
}

