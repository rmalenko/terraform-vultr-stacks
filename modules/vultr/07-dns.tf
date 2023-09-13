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
