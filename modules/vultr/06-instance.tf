data "vultr_ssh_key" "ssh_key" {
  filter {
    name   = "name"
    values = var.ssh_key_name
  }
}

resource "vultr_instance" "instanceses" {
  for_each = var.instance
  region   = var.region
  hostname = "${each.key}.${var.domain}"
  label    = "${each.key}.${var.domain}"
  tags     = each.value.instance_tags
  plan     = each.value.plan
  os_id    = each.value.os_id
  # ssh_key_ids       = [data.vultr_ssh_key.ssh_key[each.key].id]
  ssh_key_ids       = [data.vultr_ssh_key.ssh_key.id]
  enable_ipv6       = each.value.enable_ipv6
  ddos_protection   = each.value.ddos_protection
  activation_email  = each.value.activation_email
  vpc_ids           = [vultr_vpc.vpc.id]
  firewall_group_id = vultr_firewall_group.firewallgroups.id
  backups           = each.value.backups
  backups_schedule {
    type = each.value.backups_schedule
    dow  = each.value.backups_dow
    hour = each.value.backups_hour
  }
  user_data = templatefile("${path.module}/templates/cloud_config_general.tftpl",
    {
      timezone             = each.value.tz
      public_key_ecdsa_git = tls_private_key.ED25519.public_key_openssh
    }
  )
  depends_on = [tls_private_key.ED25519]
}
