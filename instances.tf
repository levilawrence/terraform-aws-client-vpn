# generate private key
resource "tls_private_key" "web" {
  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits = 2048
}

# create key pair
resource "aws_key_pair" "web" {
  key_name   = "web"
  public_key = tls_private_key.web.public_key_openssh
}

# create instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_1.id
  key_name = aws_key_pair.web.key_name
  security_groups = [aws_security_group.ec2_1.id]

  tags = {
    Name = "Server-1"
  }

  #   lifecycle {
  #       prevent_destroy = true
  #   }
}

resource "aws_instance" "bastian" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_2.id
  key_name = aws_key_pair.web.key_name

  tags = {
    Name = "Server-2"
  }

  #   lifecycle {
  #       prevent_destroy = true
  #   }
}