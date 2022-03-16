# private key
resource "tls_private_key" "pinkloop_client1" {
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P384"
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# certificate request
resource "tls_cert_request" "pinkloop_client1" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.pinkloop_client1.private_key_pem

  subject {
    common_name  = "client-1.pinkloop.com"
    organization = "pinkloop-ltd"
  }
}

#  TO DO  -  NEED CA TO PRODUCE DESCENDENT CERTS. UNSURE IF TLS LOCALLY SIGNED CERT IS CORRECT METHOD

# # produce a descendent cert
# resource "tls_locally_signed_cert" "pinkloop_client1" {
#   cert_request_pem   = tls_private_key.cert_auth.private_key_pem     # NEED REQUEST PEM FROM CA
#   ca_key_algorithm   = "RSA"
#   ca_private_key_pem = tls_private_key.cert_auth.private_key_pem
#   ca_cert_pem        = tls_self_signed_cert.cert_auth.cert_pem

#   validity_period_hours = 750

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]

#   depends_on = [
#     aws_acm_certificate.cert_auth,
#   ]
# }

# self signed certificate
resource "tls_self_signed_cert" "pinkloop_client1" {
  key_algorithm = "RSA"
  #   private_key_pem = "${file(\"private_key.pem\")}"
  private_key_pem = tls_private_key.pinkloop_client1.private_key_pem

  subject {
    common_name  = "client-1.pinkloop.com"
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
resource "aws_acm_certificate" "pinkloop_client1" {
  private_key      = tls_private_key.pinkloop_client1.private_key_pem
  certificate_body = tls_self_signed_cert.pinkloop_client1.cert_pem
  # certificate_body = tls_self_signed_cert.pinkloop_client1.cert_pem
}

# find cert
# data "aws_acm_certificate" "pinkloop_client1" {
#   domain   = "client-1.pinkloop.com"
#   statuses = ["ISSUED"]

#   depends_on = [
#     aws_acm_certificate.cert_auth,
#   ]
# }

#   # # most_recent = true
#   # # key_types   = ["EC_secp384r1"]
#   # # key_types   = ["RSA_2048"]
#   # types       = ["IMPORTED"]

#   depends_on = [
#     aws_acm_certificate.pinkloop_client1,
#     aws_acm_certificate.pinkloop_server1
#   ]
# }
