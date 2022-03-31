output "ca_cert" {

  value = tls_self_signed_cert.root_ca.cert_pem

}

output "client1_cert" {

  value = tls_locally_signed_cert.pinkloop_client1.cert_pem

}

output "server1_cert" {

  value = tls_locally_signed_cert.pinkloop_server1.cert_pem

}


#  add output to spit out private keys