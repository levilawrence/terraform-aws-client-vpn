resource aws_security_group vpn_access {
   name = "shared-vpn-access-a"
#    vpc_id = "vpc-0b491040566ea3a6b"
   vpc_id = aws_vpc.main.id
   ingress {
     from_port = 0
     protocol = "-1"
     to_port = 0
     cidr_blocks = ["0.0.0.0/0"]
   }
   egress {
     from_port = 0
     protocol = "-1"
     to_port = 0
     cidr_blocks = ["0.0.0.0/0"]
   }
 }
 
 resource aws_security_group vpn_dns {
   name = "vpn_dns"
#    vpc_id = "vpc-0b491040566ea3a6b"
   vpc_id = aws_vpc.main.id
   ingress {
     from_port = 0
     protocol = "-1"
     to_port = 0
     security_groups = [aws_security_group.vpn_access.id]
   }
   egress {
     from_port = 0
     protocol = "-1"
     to_port = 0
     cidr_blocks = ["0.0.0.0/0"]
   }
 }