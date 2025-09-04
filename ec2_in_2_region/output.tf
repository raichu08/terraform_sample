output "ec2_public_ip" {
  description = "Public IP of the EC2 instances"
  value = [
    aws_instance.instance.public_ip,
    aws_instance.instance1.public_ip
  ]
}
