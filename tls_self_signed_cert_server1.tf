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

# self signed certificate
resource "tls_self_signed_cert" "pinkloop_server1" {
  key_algorithm = "RSA"
  #   private_key_pem = "${file(\"private_key.pem\")}"
  private_key_pem = tls_private_key.pinkloop_server1.private_key_pem

  subject {
    common_name  = "vpn.pinkloop.com"
    organization = "pinkloop-ltd"
  }

  validity_period_hours = 750

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# import cert to acm
resource "aws_acm_certificate" "pinkloop_server1" {
  private_key      = tls_private_key.pinkloop_server1.private_key_pem
  certificate_body = tls_self_signed_cert.pinkloop_server1.cert_pem
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
