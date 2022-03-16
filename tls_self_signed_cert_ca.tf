# private key
resource "tls_private_key" "cert_auth" {
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P384"
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# certificate request
resource "tls_cert_request" "cert_auth" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.cert_auth.private_key_pem

  subject {
    common_name  = "ca.pinkloop.com"
    organization = "pinkloop-ltd"
  }
}

# self signed certificate
resource "tls_self_signed_cert" "cert_auth" {
  key_algorithm = "RSA"
  #   private_key_pem = "${file(\"private_key.pem\")}"
  private_key_pem   = tls_private_key.cert_auth.private_key_pem
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
resource "aws_acm_certificate" "cert_auth" {
  private_key      = tls_private_key.cert_auth.private_key_pem
  certificate_body = tls_self_signed_cert.cert_auth.cert_pem
}

# find cert
data "aws_acm_certificate" "cert_auth" {
  domain   = "ca.pinkloop.com"
  statuses = ["ISSUED"]
  # types       = ["IMPORTED"]

  depends_on = [
    # aws_acm_certificate.pinkloop_client1,
    # aws_acm_certificate.pinkloop_server1,
    aws_acm_certificate.cert_auth
  ]
}

#   # # most_recent = true
#   # # key_types   = ["EC_secp384r1"]
#   # # key_types   = ["RSA_2048"]


