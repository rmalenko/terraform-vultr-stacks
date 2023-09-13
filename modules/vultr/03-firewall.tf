resource "vultr_firewall_group" "firewallgroups" {
  description = var.firewall_name
}

resource "vultr_firewall_rule" "firewall" {
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  for_each = {
    for idx, rule in var.firewall :
    idx => {
      protocol    = can(rule.protocol) ? rule.protocol : null
      ip_type     = can(rule.ip_type) ? rule.ip_type : null
      subnet      = can(rule.subnet) ? rule.subnet : null
      subnet_size = can(rule.subnet_size) ? rule.subnet_size : null
      port        = can(rule.port) ? rule.port : null
      notes       = can(rule.notes) ? rule.notes : null
    }
  }
  protocol    = each.value.protocol
  ip_type     = each.value.ip_type
  subnet      = each.value.subnet
  subnet_size = each.value.subnet_size
  port        = each.value.port
  notes       = each.value.notes
}
