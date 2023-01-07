output "public_subnet" {
  value = aws_subnet.public_sub.id
}

output "private_subnet" {
  value = aws_subnet.private_sub.id
}

output "private_subnet_t" {
  value = aws_subnet.private_sub_t.id
}

output "vpc_name" {
    value = aws_vpc.main.id
}