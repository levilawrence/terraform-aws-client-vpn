resource "aws_ec2_client_vpn_endpoint" "vpn" {
  split_tunnel = false

  server_certificate_arn = data.aws_acm_certificate.cert_auth.arn
  #  server_certificate_arn = "arn:aws:acm:eu-west-2:505280669520:certificate/617e5203-766e-4979-b74c-f93f6ebc64bf"
  client_cidr_block = aws_subnet.subnet_1.cidr_block

  dns_servers = [
    aws_route53_resolver_endpoint.vpn_dns.ip_address.*.ip[0],
    aws_route53_resolver_endpoint.vpn_dns.ip_address.*.ip[1]
  ]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = data.aws_acm_certificate.cert_auth.arn
    # root_certificate_chain_arn = "arn:aws:acm:eu-west-2:505280669520:certificate/617e5203-766e-4979-b74c-f93f6ebc64bf"
  }

  connection_log_options {
    enabled = false
  }

}
