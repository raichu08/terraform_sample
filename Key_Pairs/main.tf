provider "aws" {
    region = "us-east-2"
    
}

# Generate a new SSH key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS as a Key Pair
resource "aws_key_pair" "example" {
  key_name   = "my-ec2-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Save private key locally (optional)
resource "local_file" "private_key_pem" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/my-ec2-key.pem"
  file_permission = "0600"
}
