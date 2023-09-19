# Vultr Servers

It is provisioning on Vultr several servers in one zone, runs Ansible tasks, and creates a GitHub repository:

- each server will have user `ssh_user_name_gitact = "gituser" # A name to use as ssh login in Github actions` with DSA key generated automatically. It allows getting SSH access to servers from GitHub actions, for example, `./modules/github/templates/ssh_action.yml`.
- the first server is considered main and has Nginx with Letsencrypt SSL `./ansible/app-server.yaml`.
- creates a GitHub repository with environment variables and secrets.

***You may skip these steps if you have already done that:***

- at first you need to add an SSH key, note its name,
- create and record the API key
- and insert the key into `terraform.tfvars` `VULTR_API_KEY = "IO....Q"`

## Variables
It the file `01-main.tf` add or, change the number of servers you need, or remove one server. Look for `# Instanse`.

### Domain and SSL certificates
These keys are used for server and host names and Ansible playbook names.

*For example:*
- `app-server` + `var.domain` = `app-server.jazzfest.link`

In this case, `app-server` is the first key `[0]`, and the public IP of this instance will be used as the primary server in this infrastructure. This server could be a load balancer or just for all wanted applications.

Important:

- IP of the first server used for `@` and `www` DNS records.
- SSL certificate (Letsencrypt) will be issued for wildcard domains: `jazzfest.link`, `*.jazzfest.link` using [Lego](https://github.com/go-acme/lego) - Let's Encrypt client and ACME library. Follow the link for more information. We assume we use Vultr DNS. And our NS servers were appropriately configured.

`sleep 90` in `05-templates.tf` may not be enough to get a letsencrypt certificate because DNS isn't propagated yet.

Define name, type, etc., for one server or many servers as you wish.

![Vultr](./docs/servers_key.png)

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

### Ansible configuration

- `app-servr = app-server.yaml` ansible playbooks name. So, each server uses its playbook, which allows for preparing specific configurations for each server. It means you must reate a playbook named as `${each.key}.yaml` in the folder `./ansible`

**Ansible**

- **role: common** will install some Linux useful console utilities and add bash aliasese to root account.

- **role: baseline** will install Docker and Docker-compose. You may change version in file `./ansible/playbook.yml`

- **role: systemd_timesyncd** synchronize time with US time servers.

- **role: node_exporter** for collect Prometheus metrics

# Github for personal uses

The module creates a number of branches, sets one of them as the default branch, and makes several environments as you wish, and each of them can have many variables and secrets.

```hcl
module "github" {
  depends_on           = [module.vultr]
  source               = "./modules/github"
  repo_name            = "testing"
  username             = "username"
  branches             = ["production", "development", "staging"]
  default_branch       = "production"
  description          = "The test terraform repository"
  visibility           = "public"
  auto_init            = true
  has_issues           = true
  has_discussions      = true
  gitignore_template   = "Terraform"
  license_template     = "apache-2.0"
  vulnerability_alerts = true
  environment_git = [
    {
      env_name      = "production"
      env_var_name  = "HOSTNAME"
      env_var_value = module.vultr.hostname_main_instance_app
    },
    {
      env_name      = "production"
      env_var_name  = "HOSTNAME_02"
      env_var_value = module.vultr.hostname_main_instance_app
    },
    {
      env_name      = "production"
      env_var_name  = "SSH_USER"
      env_var_value = module.vultr.gituser_ssh
    },

    {
      env_name      = "staging"
      env_var_name  = "HOSTNAME"
      env_var_value = module.vultr.hostname_main_instance_app
    },
    {
      env_name      = "staging"
      env_var_name  = "SSH_USER"
      env_var_value = module.vultr.gituser_ssh
    },

    {
      env_name      = "development"
      env_var_name  = "HOSTNAME"
      env_var_value = module.vultr.hostname_main_instance_app
    },
    {
      env_name      = "development"
      env_var_name  = "SSH_USER"
      env_var_value = module.vultr.gituser_ssh
    },
  ]

  secrets_git = [
    {
      env_name               = "production"
      secret_name            = "SSH_KEY_DSA"
      secret_value_plaintext = module.vultr.private_key_ecdsa
      secret_value_encrypted = base64encode(module.vultr.private_key_ecdsa)
    },
    {
      env_name               = "production"
      secret_name            = "SSH_KEY_RSA"
      secret_value_plaintext = module.vultr.private_key_rsa
      secret_value_encrypted = base64encode(module.vultr.private_key_rsa)
    },

    {
      env_name               = "staging"
      secret_name            = "SSH_KEY_RSA"
      secret_value_plaintext = module.vultr.private_key_rsa
      secret_value_encrypted = base64encode(module.vultr.private_key_rsa)
    },

    {
      env_name               = "development"
      secret_name            = "SSH_KEY_RSA"
      secret_value_plaintext = module.vultr.private_key_rsa
      secret_value_encrypted = base64encode(module.vultr.private_key_rsa)
    },
  ]
}
```


# Vultr key and API token
![Vultr](./docs/vultr_key.png)  
![Vultr](./docs/vultr_api_key.png)  
