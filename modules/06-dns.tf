resource "vultr_dns_domain" "domain" {
  count  = var.domain != "" ? 1 : 0
  domain = var.domain
}

resource "vultr_dns_record" "dns_record" {
  for_each   = var.instance
  domain     = var.domain
  name       = each.key
  data       = vultr_instance.instanceses[each.key].main_ip
  type       = "A"
  depends_on = [vultr_dns_domain.domain]
}
# To-do: add a DNS for resolving private IP to use in an application communication.

# resource "vultr_dns_domain" "internal_domain" {
#   domain = "internal.zone"
# }

# resource "vultr_dns_record" "internal_record" {
#   for_each   = var.instance
#   domain     = "internal.zone"
#   name       = each.key
#   data       = vultr_instance.instanceses[each.key].internal_ip
#   type       = "A"
#   depends_on = [vultr_dns_domain.internal_domain]
# }



# db-server.internal.zone