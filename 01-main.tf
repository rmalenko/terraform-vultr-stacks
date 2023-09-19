# The instance is a map of the number of instances. Each key is the name of the server and subdomain.
module "vultr" {
  source               = "./modules/vultr"
  domain               = var.main_domain
  ssh_key_name         = ["rostyslav"]
  ssh_user_name_gitact = "gituser" # A name to use as ssh login in Github actions
  vpc_name             = "A beautiful name of my VPC"
  region               = var.region_frankfurt_de
  vultr_apikey         = var.VULTR_API_KEY
  email_for_ssl        = var.email_for_letsencrypt

  # List of server configurations
  instance = {
    app-server = {
      instance_tags    = ["production", "app"]
      plan             = var.plan_5_usd_vc2-1c-1gb
      os_id            = var.os_id_ubuntu_22_04_lts
      enable_ipv6      = true
      backups          = "enabled"
      backups_schedule = "monthly"
      backups_dow      = 6
      backups_hour     = 1
      ddos_protection  = false
      activation_email = false
      cloud_config     = "cloud_config_app_server.yaml"
      tz               = "Europe/Kiev" # https://manpages.ubuntu.com/manpages/trusty/man3/DateTime::TimeZone::Catalog.3pm.html
    },
    # db-server = {
    #   instance_tags    = ["go", "db"]
    #   plan             = var.plan_5_usd_vc2-1c-1gb
    #   os_id            = var.os_id_ubuntu_22_04_lts
    #   enable_ipv6      = false
    #   backups          = "enabled"
    #   backups_schedule = "monthly"
    #   backups_dow      = 6
    #   backups_hour     = 1
    #   ddos_protection  = false
    #   activation_email = false
    #   cloud_config     = "cloud_config_db_server.yaml"
    #   tz               = "Europe/Berlin"
    # }
  }

  # Firewall configuration
  firewall_name = "External HTTP, SSH"
  firewall = [
    {
      protocol    = "tcp"
      ip_type     = "v4"
      subnet      = "0.0.0.0"
      subnet_size = 0
      port        = 22
      notes       = "Allow SSH connections"
    },
    {
      protocol    = "tcp"
      ip_type     = "v6"
      subnet      = "::"
      subnet_size = 0
      port        = 22
      notes       = "Allow SSH"
    },
    {
      protocol    = "tcp"
      ip_type     = "v4"
      subnet      = "0.0.0.0"
      subnet_size = 0
      port        = 80
      notes       = "Allow HTTP"
    },
    {
      protocol    = "tcp"
      ip_type     = "v6"
      subnet      = "::"
      subnet_size = 0
      port        = 80
      notes       = "Allow HTTP"
    },
    {
      protocol    = "tcp"
      ip_type     = "v4"
      subnet      = "0.0.0.0"
      subnet_size = 0
      port        = "81:82"
      notes       = "Allow HTTP for Lego to obtain SSL certificates from Letsencrypt"
    },
    {
      protocol    = "tcp"
      ip_type     = "v4"
      subnet      = "0.0.0.0"
      subnet_size = 0
      port        = 443
      notes       = "Allow HTTPS"
    },
    {
      protocol    = "tcp"
      ip_type     = "v6"
      subnet      = "::"
      subnet_size = 0
      port        = 443
      notes       = "Allow HTTPS"
    },
    {
      ip_type     = "v4"
      subnet      = "0.0.0.0"
      subnet_size = 0
      protocol    = "icmp"
      port        = ""
      notes       = "Allow ping requests"
    },
    {
      ip_type     = "v6"
      subnet      = "::"
      subnet_size = 0
      protocol    = "icmp"
      port        = ""
      notes       = "Allow ping requests"
    },
    {
      protocol    = "tcp"
      ip_type     = "v4"
      subnet      = "127.0.0.1" # Add task of get IP address of Prometheus server.
      subnet_size = 0
      port        = 9100
      notes       = "Allow Prometheus to node_exporter"
    },
    {
      protocol    = "tcp"
      ip_type     = "v6"
      subnet      = "::1" # Add task of get IP address of Prometheus server.
      subnet_size = 0
      port        = 9100
      notes       = "Allow Prometheus to node_exporter"
    },
    {
      ip_type     = "v4"
      protocol    = "tcp"
      subnet      = "127.0.0.1"
      subnet_size = 0
      port        = 9323
      notes       = "Allow Prometheus to docker exporter"
    },
    {
      ip_type     = "v6"
      protocol    = "tcp"
      subnet      = "::1"
      subnet_size = 0
      port        = 9323
      notes       = "Allow Prometheus to docker exporter"
    }
  ]
}

module "github" {
  depends_on           = [module.vultr]
  source               = "./modules/github"
  repo_name            = "testing"
  username             = "rmalenko"
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


# Man. DateTime::TimeZone::Catalog.3pm.gz
# https://manpages.ubuntu.com/manpages/focal/man3/DateTime::TimeZone::Catalog.3pm.html¸
