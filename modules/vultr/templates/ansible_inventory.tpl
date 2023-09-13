# Ansible Inventory
---
${yamlencode({
  hosting = {
    hosts = {
      for inst in instancesips : inst.hostname => {
        ansible_port = 22
        ansible_host = inst.external_ip
      }
    },
    "vars": {
      ansible_network_os = "ubuntu",
      ansible_user = "root",
      ansible_become = true,
      ansible_become_method = "sudo",
      ansible_python_interpreter = "/usr/bin/python3",
    }
  }
})}
