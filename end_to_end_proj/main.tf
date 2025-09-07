#vpc

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "my_test_vpc"
    }
}

#internet gateway for vpc 

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "my_test_igw"
    }
}

#Public subnet 

resource "aws_subnet" "ps" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-2a"
    map_public_ip_on_launch = true
    tags = {
        Name = "my_test_public_subnet"
    }
}

#Route table for public subnet

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "public_route_table"
    }
}

# route table association for public subnet

resource "aws_route_table_association" "rta" {
    subnet_id = aws_subnet.ps.id
    route_table_id = aws_route_table.public.id 
}

#Private subnet

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-2a"
    tags = {
        Name = "my_private_subnet"
    }
}

#Route table for private subnet

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "my_test_private_subnet"
    }
}

#Route table association for private subnet

resource "aws_route_table_association" "prt" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private.id
}

#Security group
resource "aws_security_group" "sg" {
    vpc_id = aws_vpc.vpc.id
    name = "ec2 sg"
    description = "security group to allow http traffic"
    ingress {
        description = "http"
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh"
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "instance" {
    subnet_id = aws_subnet.ps.id
    ami = "ami-0cfde0ea8edd312d4"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install -y apache2
                systemctl start apache2
                systemctl enable apache2
                EOF
    tags = {
        Name = "My_test_server"
    }
}
