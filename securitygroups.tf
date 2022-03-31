# Security group
resource "aws_security_group" "ec2_1" {
  name        = "ec2_1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "ec2_2" {
  name        = "ec2_2"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
}

# Security group rules
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.main.cidr_block]
  security_group_id = aws_security_group.ec2_1.id
}

resource "aws_security_group_rule" "ping" {
  type              = "ingress"
  from_port         = 8
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  # cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = aws_security_group.ec2_1.id
}