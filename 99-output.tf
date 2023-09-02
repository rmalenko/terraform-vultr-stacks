output "instances_ips" {
  value = module.vultr.instances_ips
}
output "ips" {
  value = module.vultr.ips
}

# output "certificate_crt" {
#   value = module.vultr.certificate_crt
# }

# output "certificate_key" {
#   value = module.vultr.certificate_key
#   sensitive = true
# }

output "test_ip_address" {
  value = module.vultr.test
  # sensitive = true
}