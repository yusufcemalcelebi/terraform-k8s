output "vpc" {
    value = aws_vpc.prod-vpc.id
}

output "public-subnet-1-id" {
    value = aws_subnet.public-subnet-1.id
}

output "sg-allow-web" {
    value = aws_security_group.allow-web.id
}