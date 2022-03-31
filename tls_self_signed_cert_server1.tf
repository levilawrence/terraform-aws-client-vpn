# private key
resource "tls_private_key" "pinkloop_server1" {
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P384"
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# certificate request
resource "tls_cert_request" "pinkloop_server1" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.pinkloop_server1.private_key_pem

  subject {
    common_name  = "vpn.pinkloop.com"
    organization = "pinkloop-ltd"
  }
}

# produce a descendent cert
resource "tls_locally_signed_cert" "pinkloop_server1" {
  cert_request_pem   = tls_cert_request.pinkloop_server1.cert_request_pem
  ca_key_algorithm   = "RSA"
  ca_private_key_pem = tls_private_key.root_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root_ca.cert_pem

  validity_period_hours = 750

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  depends_on = [
    aws_acm_certificate.root_ca,
  ]
}


# import cert to acm
resource "aws_acm_certificate" "pinkloop_server1" {
  private_key      = tls_private_key.pinkloop_server1.private_key_pem
  certificate_body = tls_locally_signed_cert.pinkloop_server1.cert_pem
  certificate_chain = tls_self_signed_cert.root_ca.cert_pem
}

data "aws_acm_certificate" "pinkloop_server1" {
  domain      = "vpn.pinkloop.com"

  depends_on = [
  aws_acm_certificate.pinkloop_client1,
  aws_acm_certificate.pinkloop_server1,
  aws_acm_certificate.root_ca
  ]
}

# find cert
# data "aws_acm_certificate" "issued" {
#   domain      = "*.pinkloop.com"
#   # statuses    = ["ISSUED"]
#   # # most_recent = true
#   # # key_types   = ["EC_secp384r1"]
#   # # key_types   = ["RSA_2048"]
#   # types       = ["IMPORTED"]

#   depends_on = [
#     aws_acm_certificate.pinkloop_client1,
#     aws_acm_certificate.pinkloop_server1
#   ]
# }
