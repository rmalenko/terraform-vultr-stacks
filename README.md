# Vultr Servers
It is provisioning on Vultr several servers in one zone, including Ansible tasks.

If you have already done that, you may skip these steps
- at first you need to add an SSH key, note its name,
- create and record the API key
- and insert the key into `terraform.tfvars` `VULTR_API_KEY = "IO....Q"`

It the file `01-main.tf`
Add, Change the number of servers you need, or remove one server. Look for `# Instanse`.
All variables in file `variables.tf`. I hope they are described itself.
Also, don't forget to change variable `domain = "jazzfest.link"` to your domain name.

Then run:
- `terraform init`
- `terraform plan`
- `terraform apply`

And note output. It should be the names and IPs of servers. If you forget, then run `terraform output`

**Important note!**
Save it in safe the file `terraform.tfstate` and don't expose its nowhere.

This module doesn't support save the state file on S3 or somewhere and doesn't support save the lock file to. This will be implemented in future.

**Ansible**

- **role: common** will install some Linux useful console utilities and add bash aliasese to root account.

- **role: baseline** will install Docker and Docker-compose. You may change version in file `./ansible/playbook.yml`

- **role: systemd_timesyncd** synchronize time with US time servers.

- **role: node_exporter** for collect Prometheus metrics


![Vultr](./docs/vultr_key.png)  
![Vultr](./docs/vultr_api_key.png)  


