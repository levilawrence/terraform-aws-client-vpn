# private key
resource "tls_private_key" "root_ca" {
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P384"
  algorithm   = "RSA"
  rsa_bits = "2048"
}

# certificate request
resource "tls_cert_request" "root_ca" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.root_ca.private_key_pem
  dns_names = [aws_ec2_client_vpn_endpoint.vpn.dns_name]

  subject {
    common_name  = "ca.pinkloop.com"
    organization = "pinkloop-ltd"
  }
}

# self signed certificate
resource "tls_self_signed_cert" "root_ca" {
  key_algorithm = "RSA"
  #   private_key_pem = "${file(\"private_key.pem\")}"
  private_key_pem = tls_private_key.root_ca.private_key_pem
  is_ca_certificate = true

  subject {
    common_name  = "ca.pinkloop.com"
    organization = "pinkloop-ltd"
  }

  validity_period_hours = 750

  allowed_uses = [
    "cert_signing",
    "client_auth",
    "server_auth",
    "key_encipherment",
    "digital_signature",
  ]
}

# import cert to acm
resource "aws_acm_certificate" "root_ca" {
  private_key      = tls_private_key.root_ca.private_key_pem
  certificate_body = tls_self_signed_cert.root_ca.cert_pem
}

# find cert
data "aws_acm_certificate" "root_ca" {
  domain      = "ca.pinkloop.com"
  statuses    = ["ISSUED"]

    depends_on = [
    aws_acm_certificate.pinkloop_client1,
    aws_acm_certificate.pinkloop_server1,
    aws_acm_certificate.root_ca
  ]
}

#   # # most_recent = true
#   # # key_types   = ["EC_secp384r1"]
#   # # key_types   = ["RSA_2048"]
#       types       = ["IMPORTED"]


