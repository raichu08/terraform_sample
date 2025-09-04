provider "aws" {
    region = "us-east-2"
    alias = "aa"
}

provider "aws" {
    region = "us-east-1"
    alias = "bb"
}

resource "aws_instance" "instance" {
    ami = "ami-0cfde0ea8edd312d4"
    instance_type = "t2.micro"
    provider = aws.aa
    tags = {
        Name = "hello-ohio"
    }
}

resource "aws_instance" "instance1" {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.micro"
    provider = aws.bb
    tags = {
        Name = "hello-vignia"
    }
}

