data "vultr_instance" "instance_ip" {
  for_each = var.instance
  filter {
    name   = "label"
    values = ["${each.key}.${var.domain}"]
  }
  depends_on = [vultr_instance.instanceses]
}

# Get IP addresses for first instance. Look at module 01-main.tf var.instance
data "vultr_instance" "main_instance_ip" {
  filter {
    name   = "hostname"
    values = ["${keys(var.instance)[0]}.${var.domain}"]
  }
  depends_on = [vultr_instance.instanceses]
}

locals {
  ips = {
    for k, v in data.vultr_instance.instance_ip : k =>
    {
      hostname    = v.hostname
      external_ip = v.main_ip
    }
  }
  main_instance_internal_ip = data.vultr_instance.main_instance_ip.internal_ip
}

resource "local_file" "ansible_inventory" {
  for_each = var.instance
  content = templatefile("${path.module}/templates/ansible_inventory.tpl",
    {
      instancesips = local.ips
    }
  )
  file_permission = "0644"
  filename        = "./ansible/ansible_inventory.yaml"
  depends_on      = [data.vultr_instance.instance_ip]

  provisioner "local-exec" {
    command = "export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES && sleep 90 && cd ./ansible && ansible-playbook -i ./ansible_inventory.yaml ./${each.key}.yaml --limit '${each.key}.${var.domain}' --extra-vars 'domain_name=jazzfest.link domain_name_nginx=${keys(var.instance)[0]}.${var.domain} api_key=${var.vultr_apikey} email=${var.email_for_ssl} firstinternal_ip=${local.main_instance_internal_ip}'"
  }
}

# That's actually for MacOS
# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# or 
# adding below to ~/.bash_profile works.
# export DISABLE_SPRING=true