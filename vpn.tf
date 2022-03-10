resource "aws_ec2_client_vpn_endpoint" "vpn" {
  split_tunnel = false

  # server_certificate_arn = "${data.aws_acm_certificate.issued.arn}"
   server_certificate_arn = "arn:aws:acm:eu-west-2:505280669520:certificate/58937fea-75ef-4af2-83c4-7a22eef15fe1"
  client_cidr_block = aws_subnet.subnet_1.cidr_block

  dns_servers = [
    aws_route53_resolver_endpoint.vpn_dns.ip_address.*.ip[0],
    aws_route53_resolver_endpoint.vpn_dns.ip_address.*.ip[1]
  ]

  authentication_options {
    type = "certificate-authentication"
    #  root_certificate_chain_arn = aws_acm_certificate.root_cert.arn
    root_certificate_chain_arn = "arn:aws:acm:eu-west-2:505280669520:certificate/58937fea-75ef-4af2-83c4-7a22eef15fe1"
  }

  connection_log_options {
    enabled = false
  }

}
