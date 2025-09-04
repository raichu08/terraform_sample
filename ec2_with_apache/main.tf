#security group

resource "aws_security_group" "sg" {
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
        Name = "HTTP_Server"
    }
}


