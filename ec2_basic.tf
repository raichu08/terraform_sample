resource "aws_instance" "instance" {
    ami = "ami-0cfde0ea8edd312d4"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = "testec2"
    }
}
