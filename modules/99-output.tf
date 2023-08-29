output "ips" {
  value = tomap({
    for k, ip in data.vultr_instance.instance_ip : k => ip.main_ip
  })
}

output "instances_ips" {
  value = {
    for k, v in data.vultr_instance.instance_ip : k =>
    {
      hostname    = v.hostname
      external_ip = v.main_ip
      internal_ip = v.internal_ip
    }
  }
}
