output "instance_public_ip" {
  value = aws_instance.public_instance.public_ip
  description = "Public IP of the EC2 instance"
}
