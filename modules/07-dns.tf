resource "vultr_dns_domain" "domain" {
  count  = var.domain != "" ? 1 : 0
  domain = var.domain
}

resource "vultr_dns_record" "dns_record_v4" {
  for_each   = var.instance
  domain     = var.domain
  name       = each.key
  data       = vultr_instance.instanceses[each.key].main_ip
  type       = "A"
  depends_on = [vultr_dns_domain.domain]
}

resource "vultr_dns_record" "dns_record_v4_main" {
  domain     = var.domain
  name       = "@"
  data       = data.vultr_instance.main_instance_ip.main_ip
  type       = "A"
  depends_on = [vultr_dns_domain.domain, data.vultr_instance.main_instance_ip]
}

resource "vultr_dns_record" "dns_record_v4_main_www" {
  domain     = var.domain
  name       = "www"
  data       = data.vultr_instance.main_instance_ip.main_ip
  type       = "A"
  depends_on = [vultr_dns_domain.domain, data.vultr_instance.main_instance_ip]
}

resource "vultr_dns_record" "dns_record_v6_main" {
  for_each   = var.instance
  domain     = var.domain
  name       = "@"
  data       = data.vultr_instance.main_instance_ip.v6_main_ip
  type       = "AAAA"
  depends_on = [vultr_dns_domain.domain, data.vultr_instance.main_instance_ip]
}

resource "vultr_dns_record" "dns_record_v6_main_www" {
  for_each   = var.instance
  domain     = var.domain
  name       = "www"
  data       = data.vultr_instance.main_instance_ip.v6_main_ip
  type       = "AAAA"
  depends_on = [vultr_dns_domain.domain, data.vultr_instance.main_instance_ip]
}

resource "vultr_dns_record" "dns_record_v6" {
  for_each   = var.instance
  domain     = var.domain
  name       = each.key
  data       = vultr_instance.instanceses[each.key].v6_main_ip
  type       = "AAAA"
  depends_on = [vultr_dns_domain.domain]
}

# provider "acme" {
#   server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
# }

# resource "tls_private_key" "private_key" {
#   algorithm = "RSA"
# }

# resource "acme_registration" "reg" {
#   account_key_pem = tls_private_key.private_key.private_key_pem
#   email_address   = "rmalenko+terraform_vultr@gmail.com"
# }

# resource "acme_certificate" "certificate" {
#   account_key_pem           = acme_registration.reg.account_key_pem
#   disable_complete_propagation = true
#   common_name               = var.domain
#   subject_alternative_names = concat(tolist([for k, v in var.instance : "${k}.${var.domain}"]), ["www.${var.domain}"]) # get keys of map from  var.instance and merge with other list

#   dns_challenge {
#     provider = "vultr"
#     config = {
#       VULTR_API_KEY = var.vultr_apikey
#     }
#   }
# }

# output "certificate_crt" {
#   value = acme_certificate.certificate.certificate_url
# }

# output "certificate_key" {
#   # value = acme_certificate.certificate.private_key_pem
#   value = acme_certificate.certificate
#   sensitive = true
# }