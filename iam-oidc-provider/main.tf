data "tls_certificate" "certificate" { 
  url = var.tls_certificate
}

resource "aws_iam_openid_connect_provider" "provider" {
  client_id_list  = var.oidc_provider_client_ids
  thumbprint_list = [data.tls_certificate.certificate.certificates.0.sha1_fingerprint]
  url             = var.oidc_provider_url
  tags            = merge(var.tags, {})
}