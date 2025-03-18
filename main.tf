provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a" # Change as needed
  map_public_ip_on_launch = true
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Create a security group
resource "aws_security_group" "sg" {
  name        = "allow_ssh_http_https"
  description = "Allow inbound SSH, HTTP, HTTPS, and port 8080"
  vpc_id      = aws_vpc.main.id

  # Allow inbound SSH (port 22), HTTP (port 80), HTTPS (port 443), and port 8080
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic (default behavior)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 key pair
resource "aws_key_pair" "keypair" {
  key_name   = "ubuntu-key" # Choose a name for your keypair
  public_key = file("~/.ssh/id_rsa.pub") # Ensure your public key is at this location
}

# Create an EC2 instance
resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-023a307f3d27ea427" # Ubuntu 22.04 AMI in the region
  instance_type = "t2.micro" # Choose an instance type
  key_name      = aws_key_pair.keypair.key_name
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "Ubuntu22-EC2-Instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.ubuntu_instance.public_ip
}
