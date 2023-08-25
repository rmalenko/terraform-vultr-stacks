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
  content = templatefile("${path.module}/templates/ansible_inventory.tpl",
    {
      instancesips = local.ips
    }
  )
  filename = "./ansible/hosts.yaml"

  provisioner "local-exec" {
    command = "export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES && cd ./ansible && ansible-playbook -i ./hosts.yaml ./playbook.yml"
  }
  depends_on = [data.vultr_instance.instance_ip]
}

# It's actually for MacOS
# export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# or 
# adding below to ~/.bash_profile works.
# export DISABLE_SPRING=true