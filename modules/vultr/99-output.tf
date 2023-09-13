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

output "hostname_main_instance_app" {
  value = data.vultr_instance.main_instance_ip.hostname
}

output "private_key_rsa" {
  value = trimspace(tls_private_key.rsa_4096.private_key_openssh)
  # sensitive = true
}

output "public_key_rsa" {
  value = trimspace(tls_private_key.rsa_4096.public_key_openssh)
  # sensitive = true
}

output "private_key_ecdsa" {
  value = trimspace(tls_private_key.ED25519.private_key_openssh)
  # sensitive = true
}

output "public_key_ecdsa" {
  value = trimspace(tls_private_key.ED25519.public_key_openssh)
  # sensitive = true
}
