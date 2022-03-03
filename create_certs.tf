resource "aws_acm_certificate" "root_cert" {
#   domain_name       = "pinkloopltd.com"
  domain_name = "systems-paradigm.co.uk"
#   subject_alternative_names = 
  validation_method = "EMAIL"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "server_cert" {
#   domain_name       = "vpn.pinkloopltd.com"
  domain_name = "vpn.systems-paradigm.co.uk"
  validation_method = "EMAIL"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}