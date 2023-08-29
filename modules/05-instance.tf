resource "local_file" "cloud_config_general" {
  for_each = var.instance
  content = templatefile("${path.module}/templates/cloud_config_general.tpl",
    {
      timezone = each.value.tz
    }
  )
  filename = "${path.module}/templates/${each.value.cloud_config}"
}

data "vultr_ssh_key" "ssh_key" {
  for_each = var.instance
  filter {
    name   = "name"
    values = each.value.ssh_key_name
  }
}

resource "vultr_instance" "instanceses" {
  for_each          = var.instance
  region            = var.region
  hostname          = "${each.key}.${var.domain}"
  label             = "${each.key}.${var.domain}"
  tags              = each.value.instance_tags
  plan              = each.value.plan
  os_id             = each.value.os_id
  ssh_key_ids       = [data.vultr_ssh_key.ssh_key[each.key].id]
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
  user_data = file("${path.module}/templates/cloud-config.yaml")
  # user_data = file("${path.module}/templates/${each.value.cloud_config}") # It needs to resolve the dependency. The file wasn't created before running this resource, but it must be created.
  # depends_on = [data.vultr_ssh_key.ssh_key, local_file.cloud_config_general]
  # depends_on = [local_file.cloud_config_general]
}

