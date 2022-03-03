resource null_resource client_vpn_ingress {
   depends_on = [aws_ec2_client_vpn_endpoint.vpn]
   provisioner "local-exec" {
     when    = create
     command = "aws ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.vpn.id} --target-network-cidr 0.0.0.0/0 --authorize-all-groups"
   }
   lifecycle {
     create_before_destroy = true
   }
 }
 
 resource null_resource client_vpn_route_table {
   depends_on = [aws_ec2_client_vpn_endpoint.vpn]
   provisioner "local-exec" {
     when = create
     command = "aws ec2 create-client-vpn-route --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.vpn.id} --destination-cidr-block 0.0.0.0/0  --target-vpc-subnet-id ${local.private_subnet_1}"
   }
   lifecycle {
     create_before_destroy = true
   }
 }
 
 resource null_resource client_vpn_security_group {
   depends_on = [aws_ec2_client_vpn_endpoint.vpn]
   provisioner "local-exec" {
     when = create
     command = "aws ec2 apply-security-groups-to-client-vpn-target-network --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.vpn.id} --vpc-id ${aws_security_group.vpn_access.vpc_id} --security-group-ids ${aws_security_group.vpn_access.id}"
   }
   lifecycle {
     create_before_destroy = true
   }
 }