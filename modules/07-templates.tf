data "vultr_instance" "instance_ip" {
  for_each = var.instance
  filter {
    name   = "label"
    values = ["${each.key}.${var.domain}"]
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
    command = "export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES && sleep 90 && cd ./ansible && ansible-playbook -i ./ansible_inventory.yaml ./${each.key}.yaml --limit '${each.key}.${var.domain}'"
  }
}

# That's actually for MacOS
# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# or 
# adding below to ~/.bash_profile works.
# export DISABLE_SPRING=true